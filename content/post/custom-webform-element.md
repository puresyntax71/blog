---
title: "Custom Webform Element"
date: 2019-11-15T01:38:43+08:00
draft: true
keywords: []
description: ""
tags: ['drupal', 'development', 'webform']
categories: []
resources:
    - title: Document how to add a custom WebformElement
      url: https://www.drupal.org/project/webform/issues/2877862
    - title: Adding custom data to submission lists and exports
      url: https://www.drupal.org/project/webform/issues/2897571#comment-12184156
    - title: Webform example element
      url: https://git.drupalcode.org/project/webform/tree/8.x-5.5/modules/webform_example_element
---

The [Webform](https://drupal.org/project/webform) module is a popular module that has been around since the early stages of Drupal. It allows site builders to build forms from Drupal's admin dashboard. It has a lot of features from its huge list of webform elements to exporters to integration to various popular core and contributed modules.

The version for Drupal 8 makes use of Drupal's powerful [plugin system](https://www.drupal.org/docs/8/api/plugin-api). Contributed modules can now create their own elements, exporters, etc and webform will be able to recognize it. And webform maintainer recommends to create your own plugin instead of hooking and altering existing plugins (which can also be done by using `hook_webform_*_info_alter()`).

> Whilst webform is an entity itself, it has its own implementation of form controls --- it handles the display, configuration, etc.

Recently I've been given a task to include additional data to the exporters (specifically CSV). There might be multiple ways to achieve this (e.g. creating an exporter) though I think creating an element and adding it to the existing webform seem to be a better way of handling this.

When it comes to developing a custom element, there is a need to develop a new `[FormElement](https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21Render%21Element%21FormElement.php/class/FormElement/8.2.x)` and implement a new `WebformElement` plugin. Although since all I need is to add data to the exporter, I can just create a new `WebformElement` and implement a method that handles the data export.

For this simple example, I would simply create a new webform element that uses the `value` form element that stores an Article entity ID and grab specific fields. My webform has an entityreference webform element which stores the actual Article entity ID.

To create a new `WebformElement`, I'll need to extend the base class `WebformElementBase`. It already has the basic methods needed to create a very simple webform element.

```php
<?php

namespace Drupal\custom_module\Plugin\WebformElement;

use Drupal\webform\Plugin\WebformElementBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\webform\WebformSubmissionInterface;

/**
 * Provides an 'article' element.
 *
 * @WebformElement(
 *   id = "article",
 *   label = @Translation("Article"),
 *   description = @Translation("Provides item for article."),
 *   category = @Translation("Custom"),
 * )
 */
class Article extends WebformElementBase {

    /**
     * {@inheritdoc}
     */
    public function getDefaultProperties() {
        return ['title' => ''];
    }

    /**
     * {@inheritdoc}
     */
    public function form(array $form, FormStateInterface $form_state) {
        return $form;
    }

}
```

This is the base plugin for this example element. I've overridden the `form()` method since I don't really need any additional configurations.

Since this would just use the `value` form element, I can implement the `prepare()` method and specify it with the `#type` "value":

```php
...

    /**
     * {@inheritdoc}
     */
    public function prepare(array &$element, WebformSubmissionInterface $webform_submission = NULL) {
        $element['#type'] = 'value';
        parent::prepare($element, $webform_submission);
    }

...
```

I then implemented `preSave()` method in order to give it some value upon saving. This also allows me to grab any values from the submitted webform:

```php
...
    /**
     * {@inheritdoc}
     */
    public function preSave(array &$element, WebformSubmissionInterface $webform_submission) {
        $source_data = $webform_submission->getElementData('article');
        $webform_submission->setElementData('article_1', $source_data);
    }
...
```

In this method, I've grabbed the value from the element `article` which is the key of the entityreference webform element existing on the webform element.

And finally, I just implement the methods `buildExportHeader()` and `buildExportRecord()`.

```php
    /**
     * {@inheritdoc}
     */
    public function buildExportHeader(array $element, array $options) {
        return [
            $this->t('Title'),
            $this->t('URL'),
            $this->t('Tags'),
        ];
    }

    /**
     * {@inheritdoc}
     */
    public function buildExportRecord(array $element, WebformSubmissionInterface $webform_submission, array $export_options) {
        $entity_id = $this->getValue($element, $webform_submission);

        if ($entity_id && ($entity = $this->entityTypeManager->getStorage('node')->load($entity_id))) {
            $tags = [];
            foreach ($entity->field_tags as $name) {
                $tags[] = $name->entity->label();
            }

            return [
                $entity->label(),
                $entity->toUrl('canonical', ['absolute' => TRUE])->toString(),
                implode(', ', $tags),
            ];
        }

        return parent::buildExportRecord($element, $webform_submission, $export_options);
    }
```

I've only included the fields "Title", "URL", and "Tags". CSV result export would then look like this:

{{< figure src="/images/export.png" title="Export" >}}

I think the current development experience for webform is really good. I do think there seem to be a lot of magic happening behind which would require some digging in the source. The module `[webform_example_element](https://git.drupalcode.org/project/webform/tree/8.x-5.5/modules/webform_example_element)` is a good place to start when it comes to developing a custom element.
