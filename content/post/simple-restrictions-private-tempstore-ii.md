---
title:       "Simple Restrictions Using Private Tempstore in Drupal Part II"
subtitle:    ""
description: ""
date:        2019-11-27T01:34:11+08:00
image:       "images/private.png"
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
