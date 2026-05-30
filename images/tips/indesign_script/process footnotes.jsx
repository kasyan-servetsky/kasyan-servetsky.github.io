var scriptName = "Process footnotes";

app.doScript(main, ScriptLanguage.JAVASCRIPT, undefined, UndoModes.FAST_ENTIRE_SCRIPT, "\"" + scriptName + "\" Script");

function main() {
	var doc = app.activeDocument;
	var story = app.selection[0].parentStory;
	var footnotes = story.footnotes;
	
	for (var i = 0; i < footnotes.length; i++) {
		var footnote = footnotes[i];
		footnote.texts[0].applyParagraphStyle(doc.paragraphStyles.itemByName("Footnote"), true);
	}

}