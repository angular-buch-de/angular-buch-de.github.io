---
layout:     post
title:      "Browser-Probleme bei der Verwendung von Firefox und Edge"
subtitle:   ""
date:       2017-02-10 12:00:00
author:     "Christoph Höller"
header-img: "img/post-bg-01.jpg"
---

Heute wurde ich von einem weiteren Leser darauf aufmerksam gemacht, dass es aktuell Probleme bei der Verwendung der Beispielquelltexte in Firefox und Microsoft Edge gibt.

Der Grund hierfür lieg in der Verwendung der <code>ViewEncapsulation.Native</code> Strategie in der TimePicker-Komponente. Für den Firefox konnte ich dieses Problem bereits über das Einbinden eines Polyfills lösen, für Edge suche ich aktuell noch nach einer Lösung.

Sollten Sie von diesem Browser-Problem betroffen sein, verwenden Sie bitte zwischenzeitlich die Quelltexte, die ich Ihnen unter folgendem Link bereitgestellt habe:

<a href="{{ site.baseurl }}/files/sprachkern.zip"> Korrigierte Quelltexte (Sprachkern) </a>

Hier habe ich die Strategie auf die Standard-Strategie (<code>ViewEncapsulation.Emulated</code>) geändert. Sobald ich eine echte Lösung für Edge gefunden habe, werde ich an dieser Stelle ein weiteres Update posten!

Ich wünsche Ihnen trotz der eventuell entstandnen Schwierigkeiten weiter viel Spaß mit dem Buch und bitte Sie die gegebenenfalls entstandenen Probleme zu entschuldigen!


