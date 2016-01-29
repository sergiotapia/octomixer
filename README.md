# Octomixer

[![wercker status](https://app.wercker.com/status/ae681466f773dec15e249e853206b7da/m "wercker status")](https://app.wercker.com/project/bykey/ae681466f773dec15e249e853206b7da)

Octomixer is the easiest way to find Github information on users and
organizations. Just add it as a dependency and you're good to go!

## Getting Started

TODO: I'll add a simple example app here, that uses the Octomix package.

## How does it work?

Octomizer uses a headless browser to download the HTML source code for Github's
various pages, then it scrapes the relevant information from it. In the end, you
just receive a simple Elixir hash to save, write to a file, or whatever you'd
like.
