---
title:       "Simple Restrictions Using Private Tempstore in Drupal Part II"
subtitle:    ""
description: ""
date:        2019-11-27T01:34:11+08:00
image:       "/covers/private.png"
categories:  ["Development"]
tags:        ["drupal", "api"]
---

This would be the continuation from [Part I]({{< relref "simple-restrictions-private-tempstore.md" >}}).

## Login

There would be a couple of items needed for the login feature:

* Login form to check the password.
* Login button in the "Product" content.

### Login Form

I've generated the login form using `drupal generate:form`, added the "Password" form element, and injected the service `custom_module.product_access`:

```php
<?php

namespace Drupal\custom_module\Form;

use Drupal\Core\Form\FormBase;
use Drupal\Core\Form\FormStateInterface;
use Drupal\node\Entity\Node;
use Symfony\Component\DependencyInjection\ContainerInterface;

/**
 * Class ProductLogin.
 */
class ProductLogin extends FormBase {

  /**
   * Drupal\custom_module\ProductAccessInterface definition.
   *
   * @var \Drupal\custom_module\ProductAccessInterface
   */
  protected $customModuleProductAccess;

  /**
   * {@inheritdoc}
   */
  public static function create(ContainerInterface $container) {
    $instance = parent::create($container);
    $instance->customModuleProductAccess = $container->get('custom_module.product_access');
    $instance->fieldName = $container->getParameter('custom_module.product_access.field_name');
    return $instance;
  }

  /**
   * {@inheritdoc}
   */
  public function getFormId() {
    return 'product_login';
  }

  /**
   * {@inheritdoc}
   */
  public function buildForm(array $form, FormStateInterface $form_state, Node $node = NULL) {
    $form_state->set('product', $node);

    $form['password'] = [
      '#type' => 'password',
      '#title' => $this->t('Password'),
    ];

    $form['submit'] = [
      '#type' => 'submit',
      '#value' => $this->t('Submit'),
    ];

    return $form;
  }

  /**
   * {@inheritdoc}
   */
  public function validateForm(array &$form, FormStateInterface $form_state) {
    if ($form_state->getValue('password') !== $form_state->get('product')->get($this->fieldName)->value) {
      $form_state->setErrorByName('password', $this->t('Incorrect password.'));
    }
  }

  /**
   * {@inheritdoc}
   */
  public function submitForm(array &$form, FormStateInterface $form_state) {
    $node = $form_state->get('product');
    $this->customModuleProductAccess->setAccess($node);
    $form_state->setRedirect('entity.node.canonical', ['node' => $node->id()]);
  }

}
```

The route looks like this:

```yaml
custom_module.product_login:
  path: '/product-login/{node}'
  defaults:
    _form: '\Drupal\custom_module\Form\ProductLogin'
    _title: 'Product login'
  requirements:
    _access: 'TRUE'
  options:
    parameters:
      node:
        type: entity:node
```

This is the example login form:

{{< figure src="/images/product-login.png" title="Product login" >}}

What it does is set a value for `product_access_<nid>` to `TRUE` to signify that the visitor has successfully entered the correct password.

### Login Button

The login button is also another simple link button. I've created a pseudo-field to implement this:

```php
<?php

/**
 * @file
 * Contains custom_module.module.
 */

use Drupal\Core\Entity\EntityInterface;
use Drupal\Core\Entity\Display\EntityViewDisplayInterface;
use Drupal\Core\Link;
use Drupal\Core\Url;

/**
 * Implements hook_entity_extra_field_info().
 */
function custom_module_entity_extra_field_info() {
  $extra = [];

  $extra['node']['product']['display']['product_access'] = [
    'label' => t('Product access'),
    'description' => t('The product login button.'),
    'weight' => 0,
  ];

  return $extra;
}

/**
 * Implements hook_ENTITY_TYPE_view().
 */
function custom_module_node_view(&$build, EntityInterface $entity, EntityViewDisplayInterface $display, $view_mode) {
  if ($display->getComponent('product_access')) {
    $product_access = \Drupal::service('custom_module.product_access');

    if (!$product_access->hasAccess($entity)) {
      $build['product_access'] = Link::fromTextAndUrl(
        t('Product login'),
        Url::fromRoute('custom_module.product_login', ['node' => $entity->id()])
      )->toRenderable();

      $build['product_access']['#cache']['max-age'] = 0;
    }
  }
}
```

The content page would now look like this:

{{< figure src="/images/content-product-login.png" title="Content product login" >}}

## Toggling the Elements

Now that everything is in place, I can hide or show the paragraph entities depending the access:

```php
...
/**
 * Implements hook_ENTITY_TYPE_view().
 */
function custom_module_paragraph_view(&$build, EntityInterface $entity, EntityViewDisplayInterface $display, $view_mode) {
  if ($node = \Drupal::routeMatch()->getParameter('node')) {
    $build['#cache']['max-age'] = 0;
    \Drupal::service('page_cache_kill_switch')->trigger();

    $node = $entity->getParentEntity();
    $product_access = \Drupal::service('custom_module.product_access');

    if (!$product_access->hasAccess($node)) {
      $build['#printed'] = TRUE;
    }
  }
}
...
```

I've always assumed that in order to toggle visibility of renderable arrays, I can make use of the `#access` property but it looks like for paragraph entities I needed [`#printed`](https://drupal.stackexchange.com/questions/248425/suitable-way-to-hide-a-paragraph-entity) instead. It works fine but I don't exactly know why.

This is a rough example and the actual implementation could actually use some improvements. I've disabled caching for most parts which isn't really recommended but it does seem to work for my use case.
