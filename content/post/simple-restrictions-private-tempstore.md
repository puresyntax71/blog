---
title:       "Simple Restrictions Using Private Tempstore in Drupal"
subtitle:    ""
description: ""
date:        2019-11-27T00:34:11+08:00
image:       "images/private.png"
categories:  ["Development"]
tags:        ["drupal", "api"]
---

Drupal 8 has provided some really small and helpful utilities. One of these utilities that I was able to make use of for a certain project was [`PrivateTempStore`](https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21TempStore%21PrivateTempStore.php/class/PrivateTempStore/8.7.x). This service allows developers to store a value specific to a current user's session. Another store would be [`SharedTempStore`](https://api.drupal.org/api/drupal/core%21lib%21Drupal%21Core%21TempStore%21SharedTempStore.php/class/SharedTempStore/8.7.x) which I think is mainly used for locking purposes.

A task of mine involved restricting users from viewing specific sections of a content page unless they provide the password for that content. The idea behind here is that the page would have a login button that takes them to a form where they can enter the password for that page. And, the sections that would be hidden or shown to the user are Paragraphs.

## Product Content Type

I've created a simple content type named "Product" which contains just a simple textfield "Password" and **has the machine name "field_password"**. I then removed the "Password" field from the display through the "Manage display" settings.

The "Product" content then uses [Paragraphs](https://www.drupal.org/project/paragraphs) to display its sections.

## Utility Service

The purpose of the utility service is to provide a simple abstraction for general methods for checking access. It's actually just a helper that I will be injecting in various sections of the module so that there is consistency when calling the methods.

The interface:

```php
<?php

namespace Drupal\custom_module;

use Drupal\Core\Entity\EntityInterface;

/**
 * Interface for Product access.
 */
interface ProductAccessInterface {

  /**
   * Retrieve activity access for user.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The entity.
   *
   * @return boolean
   *   TRUE if has access; otherwise FALSE.
   */
  public function hasAccess(EntityInterface $entity);

  /**
   * Set access for user.
   *
   * @param \Drupal\Core\Entity\EntityInterface $entity
   *   The entity.
   */
  public function setAccess(EntityInterface $activity);

}
```

I've defined just a few necessary methods here --- checking if user has access and setting the access for user.

The service:

```php
<?php

namespace Drupal\custom_module;

use Drupal\Core\TempStore\PrivateTempStoreFactory;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Entity\EntityInterface;

/**
 * Class for Product access.
 */
class ProductAccess implements ProductAccessInterface {

  /**
   * Drupal\Core\TempStore\PrivateTempStoreFactory definition.
   *
   * @var \Drupal\Core\TempStore\PrivateTempStoreFactory
   */
  protected $tempStorePrivate;

  /**
   * Drupal\Core\Entity\EntityTypeManagerInterface definition.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * @var string
   */
  protected $fieldName;

  /**
   * Constructs a new ProductAccess object.
   */
  public function __construct(PrivateTempStoreFactory $temp_store_private, EntityTypeManagerInterface $entity_type_manager, $field_name = NULL) {
    $this->tempStorePrivate = $temp_store_private;
    $this->entityTypeManager = $entity_type_manager;
    $this->fieldName = $field_name;
  }

  /**
   * {@inheritdoc}
   */
  public function hasAccess(EntityInterface $entity) {
    if ($entity->get($this->fieldName)->isEmpty()) {
      return TRUE;
    }

    $temporary_storage = $this->tempStorePrivate->get('custom_module');
    return $temporary_storage->get('product_access_' . $entity->id());
  }

  /**
   * {@inheritdoc}
   */
  public function setAccess(EntityInterface $entity) {
    $temporary_storage = $this->tempStorePrivate->get('custom_module');
    $temporary_storage->set('product_access_' . $entity->id(), TRUE);
  }

}
```

For this example, I've used the "parameters" to declare the field name to be used for checking. I think a better approach would be to store it as a configuration for the module.

Service `yaml`:

```yaml
parameters:
  custom_module.product_access.field_name: 'field_password'
services:
  custom_module.product_access:
    class: Drupal\custom_module\ProductAccess
    arguments: ['@tempstore.private', '@entity_type.manager', '%custom_module.product_access.field_name%']
```

As mentioned, I've defined in the `parameters` section the field name for the password. If I did `drupal debug-container --parameters`, I would see the entry for `custom_module.product_access.field_name`:

```shell
$ drupal debug:container --parameters | grep custom_module
  custom_module.product_access.field_name: field_password
```

## Login Form
