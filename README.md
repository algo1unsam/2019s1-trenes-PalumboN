# Infraestructura ferroviaria
 

Una administradora ferroviaria necesita una aplicación que le ayude a manejar las formaciones que tiene disponibles en distintos depósitos.

Una **formación** es lo que habitualmente llamamos "un tren", tiene una o varias **locomotoras**, y uno o varios **vagones**.   
En cada **depósito** hay: formaciones ya armadas, y locomotoras sueltas que pueden ser agregadas a una formación.

Vamos a resolverlo de a poco.


## Etapa 1 - vagones

En esta etapa vamos a considerar los **vagones** de cada formación.   
En el modelo debemos incluir: vagones de pasajeros, vagones de carga, y vagones dormitorio.


### Vagones de pasajeros
Para definir un vagón de pasajeros, debemos indicar el largo y el ancho medidos en metros y si tiene o no _baños_. 

A partir de estos valores, la _cantidad de pasajeros_ que puede transportar un vagón se calcula de esta forma:
- si el ancho es hasta 3 metros, entran 8 pasajeros por cada metro de largo.
- si el ancho es de más de 3 metros, entran 10 pasajeros por cada metro de largo.

P.ej.:
- un vagón de pasajeros de 10 metros de largo y 2 de ancho puede llevar hasta 80 pasajeros si está ordenado.
- otro vagón, también de 10 metros de largo, pero de 4 metros de ancho, puede llevar hasta 100 pasajeros. 

La cantidad máxima de _carga_ que puede llevar un vagón de pasajeros depende de si tiene o no baños:
- si tiene baños, entonces puede llevar hasta 300 kilos.
- si no, hasta 800 kilos.
 
 
### Vagones de carga
Para cada vagón de carga se indica su carga máxima ideal, y cuántas maderas tiene sueltas.  
Un vagón de carga puede llevar hasta su carga máxima ideal, menos 400 kilos por cada madera suelta.

P.ej. un vagón de carga con carga máxima ideal 8000 kilos con 5 maderas sueltas puede llevar hasta 6000 kilos; si cambiamos la cantidad de maderas sueltas a 2, entonces puede llevar hasta 7200 kilos.

No puede llevar pasajeros, y no tiene baños.


### Vagones dormitorio
Para cada vagón dormitorio se indica: cuántos compartimientos tiene, y cuántas camas se ponen en cada compartimiento.

La _cantidad máxima de pasajeros_ es el resultado de multiplicar cantidad de compartimientos por cantidad de camas por compartimiento.
P.ej. un vagón dormitorio con 12 compartimientos de 4 camas cada uno, puede llevar hasta 48 pasajeros.

Todos los vagones dormitorio _tienen baños_, y pueden llevar hasta 1200 kilos de carga cada uno.


### Requerimientos - información sobre una formación
A partir del modelo que se construya se tiene que poder saber fácilmente, para una formación:
- hasta cuántos pasajeros puede llevar.
- cuántos baños tiene una formación, que se obtiene como la cantidad de vagones que tienen baños (se supone que cada vagón que tiene baños, tiene uno solo).

- si la formación _está habilitada_. Esto significa que todos los vagones estén habilitados para usarse. Los vagones son revisados por los técticos cada cierto tiempo, y decimos que un vagón está habilitado si la fecha de la última revisión fue hace menos de 30 días.
_Nota: la clase [Date](https://www.wollok.org/documentacion/wollokdoc/) te puede llegar a servir para esto._

También se tiene que poder hacer _mantenimiento_ de una formación, que implica:
- actualizar la fecha de la última revisión de cada vagón al día actual.
- además, el mantenimiento de un vagón de carga conlleva arreglar dos de las maderas que tiene sueltas: si tenía 5 pasa a 3, si tenía 1 pasa a 0, si tenía 0 queda en 0.
- para el resto de los vagones no tienen ningún efecto particular que interese para este modelo. 

Por último, se quiere saber el _peso máximo total_ de la formación, que es la suma del _peso máximo_ que soporta cada vagón, esto se calcula como 80 kilos por cada pasajero que puede llevar, más el máximo de carga que soporta.


### Vagones con bicis
Hace poco, se agregaron nuevos vagones para pasajeros con lugar para transportar las bicis. Estos son como un vagón de pasajeros, pero:
- además conocemos la cantidad de bicis que entran.
- entonces la _cantidad de pasajeros_ que entran en estos vagones se calcula igual que la de pasajeros, pero restándole 2 por cada bici que puede transportar (que es ocupado por los soportes).
- ninguno tiene baño.

<br>

## Etapa 2 - locomotoras

Agregar al modelo las **locomotoras**. De cada locomotora debe indicarse: su peso, hasta cuánto peso puede arrastar, y su velocidad máxima. Decimos que una locomotora es _eficiente_ si puede arrastrar, al menos, cinco veces su peso. P.ej. una locomotora que pesa 1000 kilos y puede arrastar hasta 7000 es eficiente; si puede arrastrar hasta 3000 entonces no es eficiente.

Ahora una formación incluye locomotoras (pueden ser varias), además de vagones.

Con el modelo ampliado, tiene que poder obtenerse fácilmente, para una formación:
- su _velocidad máxima_ , que es el mínimo entre las velocidades máximas de las locomotoras.
- Si es _eficiente_; o sea, si todas sus locomotoras lo son.
- Si _puede moverse_. 
  Una formación puede moverse si la suma del arrastre de cada una de sus locomotoras, es mayor o igual al _peso máximo_ de la formación, que es: peso de las locomotoras + peso máximo de los vagones.
- Cuántos kilos de empuje le faltan a una formación para poder moverse, que es: 0 si ya se puede mover, y si no, el resultado de peso máximo total - suma de arrastre de cada locomotora.

P.ej. si una formación tiene una locomotora que pesa 1000 kilos y arrastra hasta 30000, y cuatro vagones, de 6000 kilos de peso máximo cada uno, entonces sí puede moverse, porque su peso máximo es 25000.  
Si agregamos dos vagones más de 6000 kilos, llevamos el peso máximo a 37000. Ahora la formación no puede moverse y le faltan 7000 kilos de empuje.


## Etapa 3 - depósitos
Agregar al modelo los **depósitos ferroviarios**. En cada depósito hay: formaciones ya armadas, y locomotoras sueltas.

Se pide resolver lo siguiente:
- Dado un depósito, obtener el conjunto formado por el vagón más pesado de cada formación; se espera un conjunto de vagones. 
- Saber si un depósito _necesita un conductor experimentado_.  
  Un depósito necesita un conductor experimentado si alguna de sus formaciones es compleja.
  Una formación es compleja si: tiene más de 8 unidades (sumando locomotoras y vagones), o el peso máximo total es de más de 80000 kg.
- Que un depósito pueda agregar una locomotora a una formación determinada, de forma tal que la formación pueda moverse.   
  - Si la formación ya puede moverse, entonces no se hace nada.  
  - Si no, se le agrega una locomotora suelta del depósito cuyo arrastre sea mayor o igual a los kilos de empuje que le faltan a la formación. Si no hay ninguna locomotora suelta que cumpla esta condición, debería tirar un error descriptivo.




 
