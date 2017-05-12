---
layout:     post
title:      "Details zum Angular 4 Release"
date:       2017-04-21 12:00:00
author:     "Christoph Höller"
header-img: "img/post-bg-01.jpg"
---

Als das Angular-Team im Oktober (schon vor dem endgültigen Release von Angular 2) ankündigte, dass bereits ein halbes Jahr später Angular 4 erscheinen soll war die Aufregung groß. Ein Blick in das nun erschienene 4.0er Release zeigt jedoch, dass sich die teilweise in der Community aufgekommenen Befürchtungen nicht bewahrheitet haben:

Die neue Version kommt mit einer Vielzahl interessanter Neuerungen ohne dabei Anpassungen an bestehendem Quellcode zu verlangen.

## Semantic Versioning

So verwendet Angular seit Angular 2.0 Semantic Versioning. Ohne an dieser Stelle zu sehr ins Detail zu gehen, bedeutet das, dass bei Breaking-Changes - also bei Änderungen die die API nicht-abwärtskompatibel verändern - die erste Versionsnummer hochgezählt werden muss.

Eine Besonderheit bei der Angular-Versionierung besteht hier allerdings noch darin, dass sich das Angular-Team darauf commited hat wirkliche Breaking-Changes nur über 2 Major-Versionen hinweg durchzuführen. So werden Framework-Bestandteile die in einem neuen Release durch verbesserte Konzepte abgelöst werden zunächst einmal als "deprecated" gekennzeichnet. Erst in der darauf folgenden Major-Version werden diese dann entgültig entfernt.

## Wieso 4 und nicht 3

Nun werden Sie sich gegebenenfalls fragen wieso die neue Version nun Angular 4 - und nicht wie wahrscheinlich erwartet Angular 3 - heißt. Der Grund hierfür liegt darin, dass das Routing-Modul (@angular/router) schon zu Angular-2-Zeiten die Major-Version 3 besaß. Um nun alle Module wieder auf die gleiche Major-Version zu heben, wurde also dieses Mal die Version 3 übersprungen. Details zur neuen Versions-Strategie finden Sie im Übrigen unter folgenden Link:


[http://angularjs.blogspot.de/2016/12/ok-let-me-explain-its-going-to-be.html](http://angularjs.blogspot.de/2016/12/ok-let-me-explain-its-going-to-be.html)

## Anpassungen am Beispielquellcode

In den folgenden Abschnitten möchte ich Ihnen kurz die Änderungen am Beispielquelltext des Buches vorstellen. Wie bereits oben angedeutet sind diese Änderungen nicht zwingend erforderlich, da die vorherigen Implementierungen erst mit Angular 5 entfernt werden. Nichtsdestotrotz sollten Sie aber bereits jetzt auf die neuen Techniken umsteigen.

### ng-template statt template

Im Buch beschreibe ich Ihnen an diversen Stellen die Verwendung des <code>template</code>-Tags. So wurden strukturelle Direktiven (wie z.B. die ng-If Direktive) bislang über einen <code>template</code>-Tag realisiert.

Die *-Syntax war dabei lediglich eine Kurzschreibweise für den entsprechenden <code>template</code>-Tag, sodass der Code

      <div *ngIf="isVisible>Ich werde nur dann gerendert, wenn isVisible wahr ist.</div>

in der Langschreibweise auch wie folgt ausgedrückt werden konnte.

    <template [ngIf]="isVisible">
      <div>Ich werde nur dann gerendert, wenn isVisible wahr ist.</div>
    </template>

Ein potentielles Problem dieses Ansatzes besteht hierbei allerdings darin, dass es sich beim <code>template</code>-Tag um ein HTML5-Standardtag handelt, dass insbesondere bei der Verwendung des neuen WebComponent-Standards von Bedeutung ist. Möchten Sie nun also WebComponents im Zusammenspiel mit Angular nutzen würde die bishige Implementierung zu Problemen führen. Aus diesem Grund hat sich das Angular-Team dazu entschieden das neue - Angular spezifische Tag <code>ng-template</code> einzuführen. Ab Version 4 sollten Sie somit auf folgende Schreibweise zurückgreifen:

    <ng-template [ngIf]="isVisible">
      <div>Ich werde nur dann gerendert, wenn isVisible wahr ist.</div>
    </ng-template>


### Einführung des @angular/animations Paket

Eine Änderung die hauptsächlich auf eine noch feingranularere Modularisierung abzielt ist die Einführung des <code>@angular/animations</code>-Moduls. So war die Animations-Funktionalität bislang Teil des core-Moduls, was dazu geführt hat dass auch Anwendungen die gar keine Animationen verwendet haben die entsprechenden Bestandteile inkludieren mussten. Seit Angular 4 können Sie nun  selbst entscheiden, ob Sie das Animations-Paket installieren möchten oder nicht. Die Installation erfolgt dabei wie gewohnt per npm:

    npm i @angular/animations


Im Anschluß müssen Sie nun noch alle animationsbezogenen Importe, die Sie bislang aus dem core-Modul importiert haben aus dem animations-Modul importieren:

    import {trigger,
      animate,
      style,
      transition,
      sequence,
      group,
      state
    } from '@angular/animations';

    export function growAndShrink(triggerName: string) {
      return trigger(triggerName, [
        transition(':enter', [
          sequence([
            animate('500ms ease-out', style({'transform': 'scale(2)'})),
            animate('500ms ease-in', style({'transform': 'scale(1)'})),
          ]),
        ])
      ]);
    }


### InjectionToken statt OpaqueToken

Eine weitere interessante Neuerung ist die Einführung der Klasse <code>InjectionToken</code> als Ersatz für die bisherige Klasse <code>OpaqueToken</code>. Im Vergleich zu  <code>OpaqueToken</code>s sind  <code>InjectionToken</code>s mit Hilfe von TypeScript-Generics typisiert, so dass Sie nun auch typsichere Dependency-Injection Tokens definieren können.

Das folgende Listing zeigt zunächst einmal die Definition eines Tokens, für Zahlenwerte.

    import {InjectionToken} from '@angular/core';
    export const RANDOM_VALUE = new InjectionToken<number>('random-value');


Leider ist die an dieser Stelle neu eingeführte Typ-Sicherheit (bislang?) aber nur vorgetäuscht. So ist es auch mit der neuen Version weiterhin möglich Werte die nicht dem angegebenen Generics-Typen entsprechen zu providen und an anderer Stelle zu injizieren. Der folgende Code ist somit (leider) vollkommen in Ordnung:

    const injector = ReflectiveInjector.resolveAndCreate([
       ...
       {provide: RANDOM_VALUE, useValue: 'Foo'}
    ]);


Bislang stellt der generische Typ also lediglich eine Hilfestellung für Entwickler zur Verfügung: Über einen manuellen Check des Token-Typs ist es nun möglich zu sehen, welche Art von Objekt für ein Token erwartet wird.


## TypeScript 2.1

Neben den neuen, bzw. veränderten Sprachbestandteilen besteht eine weitere wichtige Änderung darin, dass der gesamte Angular-Quellcode auf die TypeScript-Version 2.1 upgedatet wurde, was dazu führt, dass Anwendungen die auf Angular 4 basieren ebenfalls mit TypeScript 2.1 kompiliert werden müssen. Neben einer deutlich schnelleren Ausführung des Template-Compilers <code>ngc</code> stehen Ihnen mit TypeScript 2.1 eine Vielzahl an neuen, interessanten Sprachfeatures zur Verfügung. Eine Übersicht über die neuen Möglichkeiten finden Sie auf der Webseite des Projekts:

[https://www.typescriptlang.org/docs/handbook/release-notes/typescrnipt-2-1.html](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-1.html)


