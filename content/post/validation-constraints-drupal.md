---
title: "Validation Constraints in Drupal"
date: 2017-12-17T00:10:59+08:00
tags: ['api', 'validation', 'drupal']
categories: ['development']
showtoc: false
authors: [
  "Strict Panda"
]
---

Validation constraints allow a lower level of validation for entities. Unlike in Drupal 7, validation usually comes from form validation handlers. This would also mean that in order to validate entity related operations outside of forms, a developer would need to write those validations. An example is with the [services][1] module which tries to catch errors before making changes to entities. In Drupal 8, validation can now come from the Entity Validation API which can be called anytime when an operation for an entity is made.  

The Entity Validation API uses the Symfony validator. This has been integrated with the Typed Data API which would generally mean that it would function on fields and properties. Constraints are also plugins extending the class `\Symfony\Component\Validator\Constraint`. They will need to reside in the `Drupal\MODULE_NAME\Plugins\Validation\Constraint` namespace. The constraint will have a class name similar to `FooConstraint` and the validator suffixed with `Validator` which would be `FooConstraintValidator`.

## Defining the Constraint

The class would need to be in the `Drupal\MODULE_NAME\Plugins\Validation\Constraint` namespace and would typically have a class name similar to `FooConstraint.` It would also extend the class `\Symfony\Component\Validator\Constraint`.

```php
<?php

namespace Drupal\strict_panda\Plugin\Validation\Constraint;

use Symfony\Component\Validator\Constraint;

/**
 * Validation constraint for names.
 *
 * @Constraint(
 *   id = "Name",
 *   label = @Translation("Valid name.", context = "Validation"),
 * )
 */
class NameConstraint extends Constraint {

  public $message = "The name '@name' is invalid.";

}
```

### Entity Level Constraint

An entity level constraint can either use the `h\Symfony\Component\Validator\Constrainth` or `\Drupal\Core\Entity\Plugin\Validation\Constraint\CompositeConstraintBase`. The latter allowing validation for multiple properties or fields.

```php
<?php

namespace Drupal\strict_panda\Plugin\Validation\Constraint;

use Drupal\Core\Entity\Plugin\Validation\Constraint\CompositeConstraintBase;

/**
 * Validation constraint for names.
 *
 * @Constraint(
 *   id = "Names",
 *   label = @Translation("Valid name.", context = "Validation"),
 *   type = "entity:node"
 * )
 */
class NamesConstraint extends CompositeConstraintBase {

  public $message = "The names for the fields are invalid.";

  /**
   * {@inheritdoc}
   */
  public function coversFields() {
    return [
      'field_name',
      'field_name_1',
    ];
  }

}
```

## Creating the Validator

Validators go to the same namespace as the constraint with usually a class name suffixed with Validator and will extend the `\Symfony\Component\Validator\ConstraintValidator`.

> `FooConstraint` will have the validator `FooConstraintValidator` but can use another class name when `FooConstraint` overrides the method `validatedBy()`.

```php
<?php

namespace Drupal\strict_panda\Plugin\Validation\Constraint;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;

/**
 * Validates the names.
 */
class NameConstraintValidator extends ConstraintValidator {

  /**
   * {@inheritdoc}
   */
  public function validate($value, Constraint $constraint) {
    if (empty($value)) {
      return;
    }

    if ($value->value === 'A violation') {
      $this->context->addViolation($constraint->message, ['@name' => $value->value]);
    }
  }

}
```

### Entity Level Validators

```php
<?php

namespace Drupal\strict_panda\Plugin\Validation\Constraint;

use Symfony\Component\Validator\Constraint;
use Symfony\Component\Validator\ConstraintValidator;

/**
 * Validates the names.
 */
class NamesConstraintValidator extends ConstraintValidator {

  /**
   * {@inheritdoc}
   */
  public function validate($entity, Constraint $constraint) {
    if (empty($entity)) {
      return;
    }

    if ($entity->field_name->value === 'A new violation' || $entity->field_name_1->value === 'Another violation') {
      $this->context->addViolation($constraint->message);
    }
  }

}
```

> Another way to build violations is to use `buildViolation()`. An example is `$this->context->buildViolation(...)->setParameter(...)->addViolation()`.

## Setting the Field or Entity

When adding a constraint to a defined field, it can be added through annotations.

```php
...

/**
 * ...
 *
 * @FieldType(
 *   ...
 *   constraints = {"Name" => {}}
 * )
 */

...
```

When adding a constraint to a field for a defined entity, it can be added through the `baseFieldDefinitions()` method.

```php
public static function baseFieldDefinitions(EntityTypeInterface $entity_type) {
  $fields['name'] = BaseFieldDefinition::create('string')
    ->addConstraint('Name')
    ...

    return $fields;
}
```

When adding a constraint to a field for an entity defined by another module, it can be added through the hook `hook_entity_bundle_field_info_alter()`.

```php
/**
 * Implements hook_entity_bundle_field_info_alter().
 */
function strict_panda_entity_bundle_field_info_alter(&$fields, \Drupal\Core\Entity\EntityTypeInterface $entity_type, $bundle) {
  if ($entity_type->id() == 'node' && $bundle == 'article' && !empty($fields['field_name'])) {
    $fields['field_name']->addConstraint('Name');
  }
}
```

When adding a constraint to a defined entity, it can also be added through annotations.

```php
...

/**
 * ...
 *
 * @ContentEntityType(
 *   ...
 *   constraints = {"Names" => {}}
 * )
 */

...
```

When adding a constraint to an entity defined by another module, it can be added through hook `hook_entity_type_build()`.

```php
/**
 * Implements hook_entity_type_build().
 */
function strict_panda_entity_type_build(array &$entity_types) {
  $entity_types['node']->addConstraint('Names');
}
```

> `ConfigEntityType` are not yet fully supported according to this [change record][2].

[1]: http://drupal.org/project/services
[2]: https://www.drupal.org/node/2906029
