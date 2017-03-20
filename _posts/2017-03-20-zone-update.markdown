---
layout:     post
title:      "Neue Version von zone.js behebt Testing-Probleme von Observables"
date:       2017-03-20 12:00:00
author:     "Christoph Höller"
header-img: "img/post-bg-01.jpg"
---

Wie im Testing-Kapitel auf Seite 540 beschrieben besaß die bisheriger Implementierung von Angular einen schwerwiegenden Nachteil beim Testen von asynchronem Code mit Hilfe der Funktionen <code class="typescript">async</code> und <code class="typescript">fakeAsync</code>:

So war es aufgrund eines Implementierungdetails in **zone.js** bislang nicht möglich Code zu testen, der auf der <code class="typescript">setInterval</code>-Funktion basiert (hierzu gehören auch die beiden **RxJS**-Operatoren <code class="typescript">debounceTime</code> und <code class="typescript">interval</code>). Seit der Version 0.78 ist dieser Fehler aber behoben, so dass Sie sowohl <code class="typescript">async</code> als auch <code class="typescript">fakeAsync</code>, sodass Sie die beiden Funktionen ab sofort ohne Einschränkungen zum Test Ihrer asynchronen Funktionalität verwenden können.

Die Installation der neuen **zone.js**-Version kann dabei einfach über den Befehl

<code>npm i --save zone.js@^0.7.8</code>

erfolgen.


## Ein erstes Beispiel

Schauen Sie sich für ein besseres Verständnis der Funktionalität zunächst das folgende Beispiel an:

  <pre><code class="typescript">import {fakeAsync, tick, ...} from '@angular/core/testing';
it('should simulate time when using fakeAsync', fakeAsync(() => {
  let counter = 0;
  const interval = setInterval(() => {
    counter++;
  }, 200);
  tick(1000);
  expect(counter).toEqual(5);
  clearInterval(interval);
})); </code></pre>


Beachten Sie hier zunächst einmal den äußeren Rumpf des Tests:

  <pre><code class="typescript">it('should simulate time when using fakeAsync', fakeAsync(() => {
  ...
})); </code></pre>

Dadurch dass die Testausführung innerhalb der Funktion <code>fakeAsync</code> gekapselt wurde, wird der Code des Tests in einer "künstlichen Zeitzone" ausgeführt. Die Besonderheit in dieser Zone liegt darin, dass Sie Ihnen die Möglichkeit bietet die Zeit nach Belieben vorzuspulen. Doch dazu gleich mehr.

Innerhalb des Tests wird nun über die Zeilen:

<pre><code class="typescript">let counter = 0;
const interval = setInterval(() => {
  counter++;
}, 200);
</code></pre>

ein Interval gestartet, dass die Variable <code>counter</code> alle 200ms inkrementiert. Und nun wird es interessant: So haben Sie über die <code>tick</code>-Funktion die Möglichkeit künstlich in der Zeit nach vorne zu reisen. über den Aufruf

<pre><code class="typescript">tick(1000);
</code></pre>

lassen Sie also künstlich 1000ms vergehen, so dass der <code>counter</code> in dieser Zeit 5 mal erhöht wird und die Expectation


<pre><code class="typescript">expect(counter).toEqual(5);</code></pre>

erfolgreich erfüllt wird!


## Test der Typeahead Funktionalität

Wirklich interessant wird die Technik aber erst bei Test von echtem asynchronen Applikations-Code. Schauen Sie sich hierfür zunächst noch einmal die Implementierung der reaktiven Typeahead Suche aus der Datei <code>task-list.component.ts</code>.

<pre><code class="typescript">
export class TaskListComponent implements OnInit {

  tasks$: Observable<Task[]>;
  searchTerm = new FormControl();
  ...
  ngOnInit() {

    this.tasks$ = this.taskService.tasks$;

    const paramsStream = this.route.queryParams
      .map(params => decodeURI(params['query'] || ''))
      .do(query => this.searchTerm.setValue(query));

    const searchTermStream = this.searchTerm.valueChanges
      .debounceTime(400)
      .do(query => this.adjustBrowserUrl(query));

    Observable.merge(paramsStream, searchTermStream)
      .distinctUntilChanged()
      .switchMap(query =>  this.taskService.findTasks(query))
      .subscribe();
  }
}</code></pre>

Ich stelle Ihnen die Implementierung im Detail in Kapitel 12.2 ab Seite 465 vor. Für diesen Artikel ist es aber lediglich wichtig zu wissen, dass der Ausdruck:

<pre><code class="typescript">const searchTermStream = this.searchTerm.valueChanges
  .debounceTime(400)
  .do(query => this.adjustBrowserUrl(query));
}</code></pre>

dafür sorgt, dass Nutzereingaben im Suchfeld automatisch in den Stream weitergeleitet werden, sobald der Nutzer für 400 Millisekunden keine Taste mehr gedrück hat.
In Bezug auf den Test bedeutet das, dass Sie dort dafür sorgen müssen, dass nach der Eingabe der Nutzdaten (künstlich) mindestens 400 ms verstreichen. Das folgende Listing zeigt die Implementierung eines entsprechenden Tests:

<pre><code class="typescript">
  it('should call the backend to load tasks when user types in typeahead', fakeAsync(() => {
    const fixture = TestBed.createComponent(TaskListComponent);
    fixture.detectChanges();

    // Spy programmieren
    const spy = spyOn(taskService, 'findTasks');
    spy.and.returnValue(new BehaviorSubject<any>({}));

    const searchInput = fixture.nativeElement.querySelector('#search-tasks');

    const searchTerm = 'Entwickler';
    setInputValue(searchInput, searchTerm);

    //lasse 400 Millisekunden verstreichen
    tick(400);

    // Spy auswerten
    const findArguments = spy.calls.mostRecent().args;
    expect(findArguments[0]).toBe(searchTerm);
  }));
</code></pre>

Sie finden diesen Test in den aktualisierten Sourcen im Projekt <code>project-manager-reactive</code> in der Datei <code>task-list.component.spec.ts</code>.

Über die beiden Zeilen

 <pre><code class="typescript">
       // Spy programmieren
     const spy = spyOn(taskService, 'findTasks');
     spy.and.returnValue(new BehaviorSubject<any>({}));

 </code></pre>
programmieren Sie hier zunächst einen Jasmine-Spy der die findTasks-Methode des TaskService untersucht. Anschließend wird über die Zeilen
 <pre><code class="typescript">
     const searchInput = fixture.nativeElement.querySelector('#search-tasks');
     const searchTerm = 'Entwickler';
     setInputValue(searchInput, searchTerm);
 </code></pre>

der Wert des Input Feldes mit der id 'search-tasks' auf "Entwickler" gesetzt.  Mit Hilfe der <code>tick</code>-Funktion lassen Sie nun 400 Millisekunden verstreichen

 <pre><code class="typescript">
     tick(400);
 </code></pre>
und überprüfen anschließend, mit Hilfe der <code>calls.mostRecent()</code>-Funktion des Spy, dass die <code>findTasks</code>-Methode mit dem Parameter "Entwickler" aufgerufen wurde.
 <pre><code class="typescript">
     // Spy auswerten
     const findArguments = spy.calls.mostRecent().args;
     expect(findArguments[0]).toBe(searchTerm);
 </code></pre>

 Durch den Bugfix von **zone.js** haben Sie nun also die Möglichkeit mit Hilfe von <code>fakeAsync</code> und <code>tick</code> sehr elegante Tests für auf Observables basierende asynchrone Funktionalität bereitzustellen!