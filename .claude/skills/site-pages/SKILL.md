---
name: site-pages
description: Create and edit pages, posts and articles on Kasyan's static website (this repo, published on GitHub Pages as kasyan-servetsky.github.io). Use whenever the user asks to write, add, publish, update, fix or rewrite a page, post, script page, tip, snippet or text on the site, add a new script with screenshots and a zip download, or add a link to a listing page. It keeps the site's existing Dreamweaver template, CSS and markup style.
---

# Working on Kasyan's site

The site is plain static HTML that Dreamweaver manages. Nothing is generated at build time. Each page is a **Dreamweaver template instance**, and pushing to `main` on GitHub publishes the site.

**The main rule: keep the existing styling.** The look comes from `CSS/main.css` and `SpryAssets/SpryMenuBarHorizontal.css`, which every page links. New content uses only the plain tags those files already style. Don't add new CSS files, `<style>` blocks, inline `style="..."`, new classes, web fonts, frameworks or JavaScript. If a request seems to need new styling, ask the user first.

## Page anatomy

Almost every page (about 470) is built from `Templates/template_new.dwt`, an XHTML 1.0 Transitional page in UTF-8. The few Ukrainian/Cyrillic pages under `personal/metodika/` use `Templates/template_new_cyr.dwt` (HTML5, `lang="uk"`). Use the Cyrillic template only for Ukrainian-language pages.

```
<!DOCTYPE ... XHTML 1.0 Transitional ...>
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/template_new.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!-- #BeginEditable "doctitle" -->
<title>Page title</title>                         <- editable
<!-- #EndEditable -->
...Spry script + main.css links (relative paths)...
</head>
<body>
<div class="container">
  <div class="header">logo</div>
  <div class="navbar">...the whole menu...</div>   <- locked, comes from the template
  <!-- InstanceBeginEditable name="Main" -->
  <div class="main">
    <h1>Page title</h1>
    ...content...                                  <- editable
  </div>
  <!-- InstanceEndEditable -->
  <div class="footer"></div>
</div>
<script type="text/javascript">var MenuBar1 = new Spry.Widget.MenuBar(...);</script>
</body>
<!-- InstanceEnd --></html>
```

**Edit only the two editable regions**: the `<title>` and everything inside `<div class="main">`. The header, navbar, footer, `<head>` links and the Spry script at the bottom are template-locked. Dreamweaver overwrites changes to them the next time it updates pages from the template. Keep every `Instance...` and `#BeginEditable` comment exactly as it is.

If the user wants to change the menu or anything else that appears on every page, that's a template change: edit the `.dwt` and then the same block in every instance page. That touches hundreds of files, so confirm the plan with the user before starting.

## Content conventions (inside `<div class="main">`)

Copy these from existing pages rather than inventing new patterns:

| Element | How the site does it |
|---|---|
| Page title | One `<h1>`, same text as `<title>`. Use `<em>` in the h1 for product feature names when it reads better. |
| Section headings | `<h2>` for major sections, `<h3>`/`<h4>` for subsections. `<h4>` is common for "How to test it?" or a lead sentence on listing pages. |
| Body text | `<p>` paragraphs. Use `<br />` for a line break inside a paragraph. |
| Lists | `<ul><li>` / `<ol><li>` |
| UI names, file names, people's names | `<em>`: *Links* panel, *My test.indd*, by *Eugene Tyson* |
| Panel fields, options, key terms | `<strong>`: **Alt Text Source**, **Extended Description (Accessibility)** |
| Code | `<pre>` with the code escaped (`&quot;`, `&lt;`, `&gt;`, `&amp;`), usually after an `<h4>` naming the function. `<code>` for short inline bits. |
| Screenshots | `<p><img src="file.png" width="W" height="H" alt=""/></p>`. Give the image's real pixel size (read it from the file). Keep it 800 px wide or less; resizing the image file itself needs the user's OK. |
| Download link | `<p><a href="script_name.zip">Click here</a> to download the script. </p>`, usually the last paragraph |
| Author credit | `Script name by <em>Kasyan</em>` (or the other author's name) |
| Quotes | `<blockquote>` |
| Typography | Curly quotes and dashes, written as entities (`&rsquo;`, `&ldquo;`, `&rdquo;`, `&mdash;`) or as UTF-8 characters. Use `&amp;` for a literal `&`. |

Use XHTML syntax: self-closing `<br />` and `<img ... />`, lowercase tags, quoted attributes.

The writing voice is first person, friendly and practical. A script page says what the script does and which app/version it is for, shows how it works with screenshots, then gives the download link.

Older pages contain legacy markup (`xmlns` on `<p>`, `align="left"`, `dir="ltr"`, Google Docs ids, `class="bodyText"`). Leave it alone when editing nearby text, and don't copy it into new content.

## Creating a new page

1. **Pick the location.** A script page gets its own folder: `<app>/<slug>/<slug>.html`, with its screenshots and `.zip` in the same folder. Examples: `indesign/relink_images_with_tbb_catalog_numbers/relink_images_with_tbb_catalog_numbers.html`, `bridge/watched_folder/watched_folder.html`. Write slugs in lowercase with underscores, no spaces. Tips go under `tips/...` and snippets under `snippets/`. Ask the user if the right place isn't obvious.
2. **Build the page from the template**, not from an arbitrary old page:
   - Copy `Templates/template_new.dwt` to the new path.
   - Turn the template markers into instance markers:
     - add `<!-- InstanceBegin template="/Templates/template_new.dwt" codeOutsideHTMLIsLocked="false" -->` right after `<html xmlns="http://www.w3.org/1999/xhtml">`
     - change `<!-- TemplateBeginEditable name="Main" -->` to `<!-- InstanceBeginEditable name="Main" -->`
     - change `<!-- TemplateEndEditable -->` to `<!-- InstanceEndEditable -->`
     - change `</html>` at the end to `<!-- InstanceEnd --></html>`
     - keep `<!-- #BeginEditable "doctitle" -->` / `<!-- #EndEditable -->` as they are
   - **Fix relative paths.** The `.dwt` is one folder deep (`Templates/`), so all its `../` links point at the site root. For a page N folders deep, replace each leading `../` with N copies of `../` in every `href`/`src` of the head, logo and navbar. A page at `indesign/foo/foo.html` gets `../../CSS/main.css`, `../../index.html` and so on. Leave the `SpryAssets/...gif` paths in the bottom `<script>` exactly as they are. They are the same on every page.
   - Fill in `<title>` and the `<div class="main">` content.
3. **Add the files the page uses** (screenshots, zip) to the same folder. Link to them by bare filename.
4. **Link the new page from the listing pages**, or nobody will find it:
   - `scripts_by_categories.html` (root): add `<p><a href="indesign/slug/slug.html">Title</a> by <em>Kasyan</em></p>` under the matching `<h2>` category. Categories are in alphabetical order. Ask the user before creating a new category.
   - Also add the link to whichever of these fits: `indesign/my_workflow_scripts.html`, `indesign/custom_scripts.html` (scripts written for clients), `indesign/scripts.html`, `bridge/scripts_for_bridge.html`, `photoshop/scripts_for_photoshop.html`, `illustrator/...`, `acrobat/...`, `incopy/...`, `tips/all/tips_tricks.html`, `snippets/snippets.html`.
   - To mark the page as new, use the existing badge: `<img src="../images/all/new-icon.jpg" width="71" height="41" alt=""/>` (fix `../` for the listing page's depth). It goes inside the link, right after the text. Ask whether to remove the badge from older entries.
   - If a related page should point to the new one, add a cross-link sentence to it (the Bridge and InDesign alt-text pages link to each other this way).

## Editing an existing page

- Read the whole page first, change only what was asked, and keep the surrounding indentation (tabs or spaces, whichever the file uses).
- Don't reformat, re-indent or "clean up" parts of the page you weren't asked to change. Small diffs are easier for the user to review and keep Dreamweaver happy.
- If you rename or move a page, search the repo for links to it (`grep -rn "old_name.html" --include=*.html .`) and update every one.

## Don't touch

- `_notes/` folders and `dwsync.xml` files: Dreamweaver's sync bookkeeping.
- `CSS/`, `SpryAssets/` and the `.dwt` templates, unless the user explicitly asks for a site-wide style or menu change.
- `downloads/`: script archives the user supplies. Never make up a zip file. If the page needs one that doesn't exist yet, write the link and tell the user which file to add.

## Check before handing back

Run the bundled checker on every page you created or changed:

```bash
bash .claude/skills/site-pages/scripts/check_page.sh path/to/page.html [more pages...]
```

It checks that the template markers are present, balanced and in order, that the head links reach `CSS/main.css`, that all local `href`/`src` targets exist, and that each `<img>` has `width`, `height` and `alt`. Fix whatever it reports. To preview, open the page in the built-in browser with a `file:///` URL (or start a local server at the repo root) and look at it next to a similar existing page.

## Publishing

Pushing to `main` publishes the site, so don't commit or push unless the user asks. When they do, use a short commit message that names the page.
