---
title: "Third Party Settings in Drupal"
date: 2017-12-17T13:12:38+08:00
tags: ['api', 'configuration', 'drupal']
categories: ['development']
showtoc: false
authors: [
  "Strict Panda"
]
images: ["/images/settings.jpg"]
---

There would be instances where modules would need to include configurations or settings to configuration entities that are defined by other modules. Usually, this would be through altering the forms and implementing some hooks when operations are done to these entities (`hook_*_presave()`, `hook_*_insert()`, etc). Drupal 8 now has `ThirdPartySettingsInterface` which allows developers to include additional configurations associated to objects which implement this interface - `ConfigEntityInterface`.

## Altering the Form

The form still needs to be altered and set the default values using `getThirdPartySetting()`. This is an example for a block configuration entity.

```php
/**
 * Implements hook_form_alter().
 */
function strict_panda_form_alter(&$form, \Drupal\Core\Form\FormStateInterface $form_state, $form_id) {
  if ($form_id !== 'block_form') {
    return;
  }

  $block = $form_state->getFormObject()->getEntity();

  $third_party_settings = $block->getThirdPartySettings('strict_panda');

  $form['third_party_settings']['strict_panda']['name'] = [
    '#type' => 'textfield',
    '#title' => t('Name'),
    '#default_value' => $third_party_settings['name'],
  ];

  $form['third_party_settings']['strict_panda']['description'] = [
    '#type' => 'text_format',
    '#title' => t('Description'),
    '#format' => $third_party_settings['description']['format'],
    '#default_value' => $third_party_settings['description']['value'],
  ];
}
```

Simply including `third_party_settings` in the form tree automatically sets the third party settings for the configuration entity upon submission.

> Appending a callback in the `#entity_builders` array can also be used when setting third party settings with the use of `setThirdPartySetting()`.

## Adding the Schema

Schema can optionally be added as well.

```php
block.block.*.third_party.strict_panda:
  type: mapping
  label: 'Strict panda settings'
  mapping:
    name:
      type: string
      label: 'Name'
    description:
      type: boolean
      label: 'Description'
```
