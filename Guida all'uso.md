# Pigro — Guida all'uso

Pigro è un'applicazione web ideata per consentire di monitorare e gestire gli episodi delle serie di cui ci si sta occupando.

Il target è chiaramente quello dell'anime fansubbing (sottotitolazione fan-made dei prodotti d'animazione giapponese), ma nulla toglie di poterlo sfruttare come più si preferisce, grazie anche alla possibilità di apporre modifiche in maniera molto semplice ed immediata.

## Sezione 1: Show

Aggiungere uno show è molto semplice. Nella pagina "Add show" viene presentato un form composto da vari campi di testo, da compilare come segue. Eccetto per il nome della serie, la compilazione degli stessi è puramente facoltativa.

* *name*: Il nome della serie
* *number of episodes*: Il numero degli episodi di cui è composta la serie
* *fansub*: Il gruppo fansub che si occupa della sottotitolazione
* *translator*: Colui che traduce
* *editor*: Colui che adatta
* *checker*: Colui che si occupa di effettuare il check
* *timer*: Colui che effettua il timing dei sottotitoli
* *typesetter*: Colui che si occupa dello stile dei sottotitoli
* *encoder*: Colui che si occupa della codifica del video su cui verranno montati i sottititoli
* *qchecker*: Colui che si occupa controllo qualità finale

Il form si conclude con un menù a cascata che definisce lo stato della serie.

* *On going*: La sottotitolazione della serie e tutto ciò che ne concerne sono ancora in corso.
* *Finished*: La serie è stata completata in ogni sua parte.
* *Dropped*: Il fansub della serie, per un motivo o l'altro, è stato interrotto.
* *Planned*: È prevista una futura sottotitolazione della serie.

Premendo il bottone "Add", la serie verrà aggiunta nel database.

Il form presente in "Edit show" si presenta in modo analogo, e permette di modificare lo show selezionato in ogni sua parte.

Altrettanto intuitivo è "Delete show", che permette di eliminare, senza possibilità di recupero, lo show selezionato.

## Sezione 2: Episode

Discreta attenzione merita la gestione degli episodi di cui sono composti gli show creati precedentemente, sebbene i form di cui sono composti le relative pagine sono impostati all'incirca in maniera analoga.

Dopo aver selezionato lo show a cui aggiungere un episodio, si ottiene un form in cui è già preimpostato il nome della serie d'appartenenza e il numero dell'episodio che si sta andando a creare (se è il primo episodio sarà naturalmente 1, altrimenti il numero successivo a quello dell'ultimo aggiunto).
Successivamente si hanno delle checkbox da spuntare, che indicano che i seguenti compiti sono stati portati a termine.

* *Translation*: L'episodio è stato tradotto
* *Editing*: L'episodio è stato adattato
* *Checking*: L'episodio è stato checkato
* *Timing*: Il timing dei sottotitoli è stato effettuato
* *Typesetting*: Il typeset dei sottotitoli è stato effettuato
* *Encoding*: La codifica video è stata portata a termine
* *QC*: L'episodio finale è stato visionato ed è perciò pronto al rilascio

Si aggiunge un campo di testo dove aggiungere il link al download dell'episodio.

Notevole attenzione, per via delle loro potenzialità, meritano la checkbox "Apply globally" e il successivo campo di testo.
Allorquando si spunti il primo componente, verranno creati (o, se già presenti, modificati) *n* episodi che presentano gli stessi dati (ovvero lo stato in cui si trova l'episodio e l'URL di download) di quello che ci si accinge a creare.

Un esempio pratico è il seguente: sono pronti tutti gli episodi dal numero 4 al numero 10 di una serie da 12 episodi. Per aggiungerli tutti in una sola istanza, si spuntano tutte le checkbox e si inserisce il link di download nel form relativo all'episodio 4, si spunta "Apply globally" e si compila il successivo campo di testo con il numero 10.
Ci si ritroverà quindi a creare successivamente l'episodio numero 11.

In egual modo è possibile sia cancellare sia apportare modifiche agli episodi in blocco utilizzando le relative funzioni presenti in "Edit episode" e "Delete episode."