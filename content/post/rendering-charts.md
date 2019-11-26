---
title:       "Rendering Charts in Drupal using c3js"
subtitle:    ""
description: ""
date:        2019-11-26T16:07:55+08:00
image:       "images/charts.png"
categories:  ["Development"]
tags:        ["drupal", "c3js", "api"]
draft:       true
---

One of the projects I've worked on before needed a chart that displays asset values for funds. The requirement was to allow editors to modify imported data and display it as a simple line chart in a content page using [d3js](https://d3js.org/).

In order to accomplish this feature, the items I planned on doing were:

* Create a content type that stores the actual fund.
* Create a content type to store the asset values.
* Have a field to be displayed on the content page for funds.
* Retrieve the asset values from a fund and display it as a line chart.

> Since this is an example, the listed items are not complete/partially correct although they are somewhat similar.

## Fund

The only field necessary for the "Fund" content type would just be the title. I simply created a new content type with some sane defaults and named it "Fund".

## Asset Value

For the "Asset Value" content type, I added three fields:

* Date - stores a date only data.
* Value - stores the asset value in decimal format.
* Fund - entityreference field referencing the "Fund" content type.

I originally added a paragraph field to the "Fund" content type although since the values contained a lot of data, the UI became slow and sluggish so I decided to just separate it. We then created a view to list the asset values which has necessary filtering for easy searching of "Asset Value" content.
