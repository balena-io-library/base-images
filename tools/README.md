Dynamic Dockerfile
======================

> Dynamic Dockerfile generation with metalsmith-dynamic and smart imports.

So, here's how the thing works:

You define some **dictionaries** in the `dicts` folder A **dictionary** is either a JSON file that contains an array, or a CommonJS module (JS or CoffeeScript) that exports such an array.
The array can contain any number of objects (**values**). Each object _must_ contain a unique (within the given **dictionary**) `id` field. It can also contain any number of additional fields.

The files in `src` folder are converted into the files in `dist` folder, by default 1-to-1. During the conversion the files are processed with `Handlebars` engine.

That allows you to use _partials_ to isolate or reuse pieces of text. Any file in `partials/path/to/file.part` (extension can be arbitrary, it's conventional) can be included as `{{> "path/to/file" }}`.

The exception to the 1-to-1 rule (and the main feature of this project) is **dynamics** files. A file is **dynamic** if it has a `dynamic` front-matter annotation (check `Dockerfile.tpl` for an example). The dynamic file defines the **variables** to be populated, each **variable** name _must_ be of form `$<dictionary file name>`. Such **dynamic** files are expanded over each possible combination of **variables**. The target filenames are defined by the `ref` parameter. By default the file extension is being kept, but this can be overridden by setting `skip_ext: true` (compare `Dockerfile.tpl` and `entry.sh`). In the `ref` `$<variable>` corresponds to the to the `id` from the `<variable>` dictionary.

So, for each possible combination of the defined **variables** a new file will be created in the `dist` directory accroding to the `ref` naming scheme. Additionally before being written to the disk this file is also processed with `Handlebars` engine. During that `$<variable>` will be available in the Handlebars context and will correspond to the entire **dictionary** object (see how we use `{{ $distro.name }}` in the Dockerfile comment).

So why is it important? First, you can interpolate `id`s or any custom properties from the **dictionary** objects (see how we conventionally build the `FROM` clause).

But there's one more power feature — _smart imports_. They're like partials on steroids. So if you write `{{ include "my/smart/partial" }}` the files in the `partials/my/smart/partial` _folder_ will be checked and the most _specific_ will be used. Having `N` variables `var1`, `var2`, ..., `varN` the following filenames will be tried in order:

- `var1+var2+...+varN.part`
- `var1+var2+...+var{N-1}.part` (all but `varN`)
- `var1+var2+...+var{N-2}+varN.part` (all but `var{N-1}`)
- ...
- `var1.part`
- ...
- `varN.part`
- `_default.part`

That allows you to have smart overrides for files or groups of files. For example, the `partials/install` directory has overrides for _all alpine_ images, and for _all fedora_ images, as well as an empty default (should we add more distros to the dict). It could also have an override for _all i386_ images (the `$arch` would have higher specificity because that variable is defined earlier in the list), or even a very specific override for `i386+fedora`.

License
-------

The project is licensed under the Apache 2.0 license.
