---

    title: "11. HTTP: Anbindung von Angular-Applikationen an einer Webserver"

---
Die Anbindung von externen Services erfolgt im Webumfeld fast
immer per HTTP. Neben dem Ausführen von Requests und der Verarbeitung von Responses bedeutet dies auch, dass Ihre Anwendung
nun mit asynchronen Daten zurechtkommen muss: Das AngularHTTP-Framework macht dies zu einem Kinderspiel!

So werden Sie mit Abschluss dieses Kapitels wissen:

- welche Methoden Ihnen der **HttpClient**-Service zur Anbindung von HTTP-Backends
zur Verfügung stellt.
- warum Observable-Streams eine deutliche Verbesserung zum klassischen Callback-Pattern darstellen.
- wie das HTTP-Framework Sie bei der Arbeit mit Query-Parametern und HeaderWerten unterstützt.
- wie Sie mithilfe der AsyncPipe für eleganten Komponenten-Code sorgen können und wann dieser Ansatz an seine Grenzen stößt.
- was JsonP ist und wie Ihnen das HTTP-Framework die Arbeit mit dieser Technik vereinfacht.

Quellcode zum Kapitel: [github.com/angularbuch/project-manager-http](github.com/angularbuch/project-manager-http){:target="_blank"}
