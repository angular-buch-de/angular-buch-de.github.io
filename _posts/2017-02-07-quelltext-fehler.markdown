---
layout:     post
title:      "Fehler in den Beispielquelltexten (Internationalisierung)"
subtitle:   ""
date:       2017-02-07 12:00:00
author:     "Christoph Höller"
header-img: "img/post-bg-01.jpg"
---

Leider haben sich durch das Update der Beispielquelltexte des Internationalisierungs-Kapitels einige kleinere Fehler eingeschlichen, so dass Sie ab sofort unter dem Link ["Beispielquelltexte"](https://s3-eu-west-1.amazonaws.com/gxmedia.galileo-press.de/supplements/3988/3914_Zusatzmaterialien.zip) eine akualsierte Fassung der Beispiele finden.

Der Hauptgrund für das fehlerhafte Verhalten des Projekts lag in der bisherigen Version darin, dass mit Angular 2.4.3 ein Bug eingeführt wurde (Details finden Sie unter [https://github.com/angular/angular/issues/13624](https://github.com/angular/angular/issues/13624)), der verhindert dass sich der für Tests verwendete Animations-Treiber per AOT kompilieren lässt. Da das Tool zur Generierung von Übersetzungen (**ng-xi18n**) jedoch lediglich mit AOT-kompatiblem Code funktioniert führte die Ausführung des Befehls:

<code>
npm run translate
</code>

zu folgendem Fehler führt

<img src="{{ site.baseurl }}/img/no-op-error.png" alt="Post Sample Image">


(Details zu den Gründen, aus denen Inline-Funktionen nicht AOT-kompatibel sind finden Sie im Buch in Abschnitt "16.4.3 Verzicht auf Inline-Funktionen" auf Seite 603)


Die Lösung für das Problem besteht nun darin, den Test-Code von der Kompilierung auszuschließen. Des Weiteren ist es ebenfalls sinnvoll bereits durch den AOT-Compiler kompilierten Code nicht erneut von **ng-xi18n** auch mgöliche Übersetzungen untersuchen zu lassen. Erweitern Sie hierfür einfach die <code>tsconfig.json</code> mit dem folgenden exclude-Statement:

<pre><code class="json">{
  "compilerOptions": {
     ...
   },
   "exclude": [ "test.ts", "main-aot.ts"]
}
</code></pre>

Im Anschluß müssen Sie lediglich noch dafür sorgen, dass der Befehl <code>npm run translate</code> die <code>tsconfig.json</code> verwendet. Erweitern Sie hierfür den Script-Aufruf in der <code>package.json</code> wie folgt

<pre><code class="json">"scripts": {
    "translate": "ng-xi18n -p ./src/tsconfig.json",
    ...
  },
</code></pre>

Ein erneuter Start der Translation-Generierung sollte nun ohne den initial dargestellten Fehler funktionieren.

Besten Dank an Herrn Pätzold für das aufspüren des Fehlers und die konstruktive Kritik!