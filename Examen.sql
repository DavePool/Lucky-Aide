create database luckyaide;
drop database luckyaide;
use luckyaide;

----1)
---Tablas fuertes
create table proveedor(id_proveedor int identity, nombre varchar(40), direccion varchar(40), calle varchar(30), colonia varchar(20), numero varchar(10), ciudad varchar(20), cp int, primary key (id_proveedor));
create table categoria(id_categoria int identity, nombre varchar(30), descripcion varchar(80), primary key(id_categoria));
create table cliente(id_cliente int identity, nombre varchar(40), direccion varchar(40), calle varchar(30), colonia varchar(20), numero varchar(10), ciudad varchar(20), cp int, primary key(id_cliente));  
create table venta(id_venta int identity, fecha datetime, total money, descuento int, primary key(id_venta));
create table producto(id_producto int identity, nombre varchar(120), precio money, existencias int, primary key(id_producto));
create table vendedor(id_vendedor int identity, nombre varchar(30), fecha_contrato date, fecha_nacimiento date, escolaridad varchar(30), primary key(id_vendedor));
select max(id_venta) from venta;

---Tablas debiles
create table provee(id_provee int identity not null, id_proveedor int, id_producto int, fecha datetime, cantidad int);
create table clasifica(id_clasifica int identity not null, id_categoria int, id_producto int );
create table detalle(id_detalle int identity not null, id_producto int, id_venta int, cantidad int, fecha datetime);
create table compra(id_compra int identity not null, id_venta int, id_cliente int);
create table realiza(id_realiza int identity not null, id_venta int, id_vendedor int);
select provee.id_provee, proveedor.nombre, producto.nombre, provee.fecha, provee.cantidad from proveedor inner join provee on proveedor.id_proveedor=provee.id_proveedor inner join producto on producto.id_producto=provee.id_producto;
select clasifica.id_clasifica, categoria.nombre, producto.nombre from categoria inner join clasifica on categoria.id_categoria=clasifica.id_categoria inner join producto on producto.id_producto=clasifica.id_producto;
select detalle.id_detalle, producto.nombre, venta.id_venta, venta.total, detalle.cantidad, detalle.fecha from producto inner join detalle on producto.id_producto=detalle.id_producto inner join venta on venta.id_venta=detalle.id_venta;
select compra.id_compra, venta.id_venta, venta.fecha, venta.total, cliente.nombre from venta inner join compra on venta.id_venta=compra.id_venta inner join cliente on cliente.id_cliente=compra.id_cliente;
select realiza.id_realiza, venta.id_venta, venta.fecha, venta.total, vendedor.nombre from realiza inner join venta on venta.id_venta=realiza.id_venta inner join vendedor on vendedor.id_vendedor=realiza.id_vendedor;
----2)
---Valores por defecto, indices y restricciones

--Proveedor
create rule RG_proveedor_rangocp as @cp between 9999 and 99999;
exec sp_bindrule RG_proveedor_rangocp, 'proveedor.cp'
alter table proveedor add constraint DF_proveedor_nombre default 'Desconocido' for nombre;
alter table proveedor add constraint DF_proveedor_direccion default 'Desconocida' for direccion;
alter table proveedor add constraint DF_proveedor_calle default 'Desconocida' for calle;
alter table proveedor add constraint DF_proveedor_colonia default 'Desconocida' for colonia;
alter table proveedor add constraint DF_proveedor_numero default 'Desconocido' for numero;
alter table proveedor add constraint DF_proveedor_ciudad default 'Desconocida' for ciudad;
alter table proveedor add constraint DF_proveedor_cp default 1000 for cp;

--Categoria
alter table categoria add constraint DF_categoria_nombre default 'Desconocido' for nombre;
alter table categoria add constraint DF_categoria_descripcion default 'No especificada' for descripcion;

--Cliente
create rule RG_cliente_rangocp as @cp between 9999 and 99999;
exec sp_bindrule RG_cliente_rangocp, 'cliente.cp'
alter table cliente add constraint DF_cliente_nombre default 'Desconocido' for nombre;
alter table cliente add constraint DF_cliente_direccion default 'Desconocida' for direccion;
alter table cliente add constraint DF_cliente_calle default 'Desconocida' for calle;
alter table cliente add constraint DF_cliente_colonia default 'Desconocida' for colonia;
alter table cliente add constraint DF_cliente_numero default 'Desconocido' for numero;
alter table cliente add constraint DF_cliente_ciudad default 'Desconocida' for ciudad;
alter table cliente add constraint DF_cliente_cp default 1000 for cp;

--Venta
create rule RG_venta_rangodescuento as @descuento between 0 and 100;
exec sp_bindrule RG_venta_rangodescuento, 'venta.descuento';
alter table venta add constraint DF_venta_fecha default getDate() for fecha;
alter table venta add constraint CK_venta_total check (total is not null); 
alter table venta add constraint DF_venta_descuento default 0 for descuento;

--Producto
alter table producto add constraint DF_producto_nombre default 'Desconocido' for nombre;
alter table producto add constraint CK_producto_precio check (precio is not null);
alter table producto add constraint CK_producto_existencias check (existencias>0);

--Vendedor
alter table vendedor add constraint DF_vendedor_nombre default 'Desconocido' for nombre;
alter table vendedor add constraint DF_vendedor_fechacontrato default getDate() for fecha_contrato;
alter table vendedor add constraint CK_vendedor_fechanacimiento check (fecha_nacimiento is not null);
alter table vendedor add constraint DF_vendedor_escolaridad default 'Desconodica' for escolaridad;

/*----------------------------------------restruccuines para tablas debiles----------------------------------------------------------
create table provee(id_provee int, id_proveedor int, id_producto int, fecha datetime, cantidad int);*/
alter table provee  add constraint PK_id_provee primary key(id_provee);
alter table provee add constraint CK_id_proveedor check(id_proveedor is not null);
alter table provee add constraint CK_id_producto check (id_producto is not null);
alter table provee add constraint DF_fecha_ingreso default getDate() for fecha;
alter table provee add constraint UQ_realiza_provee unique(id_provee);


/*
create table clasifica(id_clasifica int indentity, id_categoria int, id_producto int );*/
alter table clasifica  add constraint PK_id_clasifica primary key(id_clasifica);
alter table clasifica add constraint CK_id_categoria check(id_categoria is not null);
create unique nonclustered index I_clasifica_cetegoria on clasifica(id_categoria); 
create unique nonclustered index I_clasifica_id_producto on clasifica(id_producto);
alter table clasifica add constraint CK_clasifica_id_producto check (id_producto is not null);
alter table clasifica add constraint UQ_realiza_id_categoria unique(id_categoria);
alter table clasifica add constraint UQ_realiza_id_producto unique(id_producto);
/*
create table detalle(id_detalle int indentity, id_producto int, id_venta int, cantidad int, fecha datetime);
*/

alter table detalle add constraint PK_id_detalle primary key(id_detalle);
alter table detalle add constraint CK_detalle_id_producto check(id_producto is not null);
alter table detalle add constraint CK_detalle_id_venta check(id_venta is not null);
alter table detalle with nocheck add constraint CK_cantidad check (cantidad > 0);
alter table detalle add constraint DF_detalle_fecha default getDate() for fecha;
alter table detalle add constraint UQ_realiza_iddetalle unique(id_detalle); 
create unique nonclustered index I_id_detalle on detalle(id_detalle);

/*
create table compra(id_compra int identity, id_venta int, id_cliente int);
*/

alter table compra add constraint PK_id_compra primary key(id_compra);
create unique nonclustered index I_id_cliente on compra(id_cliente);
create unique nonclustered index I_id_venta on compra(id_venta);
alter table compra add constraint CK_compra_id_cliente check(id_cliente is not null);
alter table compra add constraint CK_compra_id_venta check(id_venta is not null);
alter table compra add constraint UQ_compra_id_venta unique(id_venta);
alter table compra add constraint UQ_compra_id_cliente unique(id_cliente);
/*
create table realiza(id_realiza int identity, id_venta int, id_vendedor int);
*/

alter table realiza add constraint PK_id_realiza primary key(id_realiza);
create unique nonclustered index I_realiza on realiza(id_realiza);
create unique nonclustered index I_id_venta on realiza(id_venta);
alter table realiza add constraint CK_realiza_id_cliente check(id_vendedor is not null);
alter table realiza add constraint CK_realiza_id_venta check(id_venta is not null);
alter table realiza add constraint UQ_realiza_id_venta unique(id_venta);
drop index I_id_venta on detalle(id_venta);

/*---------------------------------------------------Inicio insert tablas fuertes-------------------------------------------------------------------------*/
/*
    _____   _______ __________  ___________    _______   __   _________    ____  __    ___   _____    ________  ____________  _________________
   /  _/ | / / ___// ____/ __ \/_  __/ ___/   / ____/ | / /  /_  __/   |  / __ )/ /   /   | / ___/   / ____/ / / / ____/ __ \/_  __/ ____/ ___/
   / //  |/ /\__ \/ __/ / /_/ / / /  \__ \   / __/ /  |/ /    / / / /| | / __  / /   / /| | \__ \   / /_  / / / / __/ / /_/ / / / / __/  \__ \ 
 _/ // /|  /___/ / /___/ _, _/ / /  ___/ /  / /___/ /|  /    / / / ___ |/ /_/ / /___/ ___ |___/ /  / __/ / /_/ / /___/ _, _/ / / / /___ ___/ / 
/___/_/ |_//____/_____/_/ |_| /_/  /____/  /_____/_/ |_/    /_/ /_/  |_/_____/_____/_/  |_/____/  /_/    \____/_____/_/ |_| /_/ /_____//____/  
                                                                                                                                               
*/

insert into categoria values ('Carnes y embutidos', 'Dispondrá de la mejor selección de carnes de nuestras razas autóctonas.');
insert into categoria values ('Frutas y verduras' , 'Una cuidada y selecta variedad de frutas y verduras.');
insert into categoria values ('Panadería y Dulces', 'Para todos los gustos: de trigo, centeno, integral, cereales y más');
insert into categoria values ('Huevos, Lácteos y café', 'Huevos ricos en antioxidantes, ácidos grasos y vitaminas.');
insert into categoria values ('Aceites, pastas y Legumbres', 'Aceites de altísima calidad, en aroma y sabor; de mucha variedad.');
insert into categoria values ('Zumos y bebidad', 'Zumos elaborados de forma artesana que garantiza la máxima calidad.');
insert into categoria values ('Aperitivos' , 'Con el mejor aceite de oliva se elaboran estos productos de la mayor calidad.');
insert into categoria values ('Infantil' , 'Para los consumidores más pequeños, ofrece una alimentación ecológica y más');
insert into categoria values ('Cuidado Personal', 'La auténtica cosmética natural, basada en el aceite de oliva virgen');
insert into categoria values ('Hogar y limpieza', 'Limpieza ecológica de verdad. Hace posible la sostenibilidad del hogar');
insert into categoria values ('Cremas','Las mejores cremas para la piel');
insert into categoria values ('Vinos y Licores','El mejor alcohol para tomar en casa con amigos y familia');
insert into categoria values ('Muebles','Los mejorex muebles de la mejor calidad para su hogar');
insert into categoria values ('Celulares','Las mejores marcas de moviles con las utlimas actualizaciones');
insert into categoria values ('Audio y video','La mejor calidad de producto para el uso en casa y portatil');
insert into categoria values ('Ropa','Las mejores prendas que puedes usar en esta temporada');
insert into categoria values ('Jardín','Los mejores aditamentos para tener un jardín increible');
insert into categoria values ('Calzado','El mejor calzado y de la mejor calidad que podras ver en esta temporda');
insert into categoria values ('Computadoras','Las mejores marcas con las caracteristicas más altas que podras encontrar');
insert into categoria values ('Accesorios','Encuntra accesorios para tu movil o computadora');
insert into categoria values ('Videojuegos','La mejor diversion para ti y tus hijos');
insert into categoria values ('Linea de blancos','Encuntra la mejor calidad de blancos mas blancos');
insert into categoria values ('Mascotas','Conciente a tus Mascotas con nuestros productos');
insert into categoria values ('Ferreteria y automotriz','Encuntra accesorios para tu movil  y ferreteria con productos 100% garantizados');
insert into categoria values ('Deportes','Los mejores productos deportivos para deportistas de alto rendimiento');
insert into categoria values ('Marcas propias','No te dejes engañar, contamos con los mejores productos igualando a marcas de importacion');
insert into categoria values ('Farmacia','Todo lo que te puedas imaginar en productos para la salud una amplia gama mas que la del IMSS');
insert into categoria values ('Perfumeria','aromatiza tu dia con nuestras mejores fragancias');
insert into categoria values ('Limpieza','cualquier articulo de limpieza lo tenemos');
insert into categoria values ('Oficina y papeleria','Office depot y office max nos nuestros clientes, que mas podemos decir');


-----------------------------------------------------------------Insert para celculares-----------------------------------------------------------------
insert into producto values ('MotoG2',1800,4571);
insert into producto values ('MotoG2 plus',1950,1000);
insert into producto values ('MotoG3',3000,250);
insert into producto values ('MotoG3 plus',3200,1564);
insert into producto values ('MotoG4',3300,500);
insert into producto values ('MotoG4 plus',4500,785);
insert into producto values ('MotoG5',5200,4521);
insert into producto values ('MotoG5 plus',5800,4523);
insert into producto values ('Moto x',5450,42265);
insert into producto values ('Moto x play',5500,4523);
insert into producto values ('Moto z',6100,422);
insert into producto values ('Moto z play',6500,4226);
insert into producto values ('Moto z play 2',7000,452);
insert into producto values ('Moto x4',7200,41);
insert into producto values ('LG Zone',2100,14);
insert into producto values ('LG Magna',1200,4000);
insert into producto values ('LG JOY',1000,45);
insert into producto values ('LG g5',2600,4512);
insert into producto values ('LG flex',2300,6);
insert into producto values ('LG flex 2',2800,7552);
insert into producto values ('LG Q2',1200,1512);
insert into producto values ('LG Q3',1100,6542);
insert into producto values ('LG Q4',2450,612);
insert into producto values ('LG Q5',2600,452);
insert into producto values ('LG Q6',3800,6523);
insert into producto values ('Samsung S2',4500,200);
insert into producto values ('Samsung S3',4580,1542);
insert into producto values ('Samsung S4',6500,563);
insert into producto values ('Samsung S5',3600,3463);
insert into producto values ('Samsung S6',5899,35);
insert into producto values ('Samsung S6 plus',6799,345);
insert into producto values ('Samsung S7',9500,56);
insert into producto values ('Samsung S7 plus',10200,54);
insert into producto values ('Samsung S8',12600,15000);
insert into producto values ('Samsung S8 plus ',15000,7);
insert into producto values ('Samsung Note 8',23999,747);
insert into producto values ('Samsung Note 8 plus',26999,554);
insert into producto values ('Samsung Ace',1800,5);
insert into producto values ('Samsung Ace 2',2499,4334);
insert into producto values ('Samsung GrandPrime',2600,4543);

------------------------------------Insert para ropa----------------------------------
insert into producto values ('Pantalón Mezclilla',82,4522);
insert into producto values ('Pantalón azul',45,565);
insert into producto values ('Pantalón rojo',34,345);
insert into producto values ('Pantalón morado',34,545);
insert into producto values ('Pantalón verde',86,67856);
insert into producto values ('Pantalón rosa',477,657);
insert into producto values ('Pantalón amarillo',34,345);
insert into producto values ('Pantalón blanco',346,687);
insert into producto values ('Pantalón piel',477,567);
insert into producto values ('Pantalón tela',477,678);
insert into producto values ('Blusa rosa',345,687);
insert into producto values ('Blusa negra',566,9765);
insert into producto values ('Blusa morada',456,656);
insert into producto values ('blusa verde',456,8900);
insert into producto values ('Blusa roja',898,7897);
insert into producto values ('Blusa amarilla',877,34);
insert into producto values ('Blusa tela',343,689);
insert into producto values ('Blusa cuadros',345,45);
insert into producto values ('Blusa unicormios',65,767);
insert into producto values ('Blusa pollos',56,899);
insert into producto values ('Blusa patos',877,45);
insert into producto values ('Blusa triangulos',466,6767);
insert into producto values ('Blusa puntitos ',33,676);
insert into producto values ('Calcetines',456,7);
insert into producto values ('Calzones',464,7);
insert into producto values ('Boxer',456,7);
insert into producto values ('Tanga',454,8);
insert into producto values ('Playera',456,54);
insert into producto values ('Playera azul',456,45645);
insert into producto values ('Playera verde',465,64);
insert into producto values ('Playera gallos',56,64);
insert into producto values ('Playera cruzAzul',564,53);
insert into producto values ('Playera pumas',356,3);
insert into producto values ('Playera deportiva',244,76);
insert into producto values ('Playera UPQ Negocios',457,976);
insert into producto values ('Playera UPQ Sistemas',999999,7786);
insert into producto values ('Playera UPQ Mecatrónica',56,656);
insert into producto values ('Playera UPQ PYMES',2,5);
insert into producto values ('Playera UPQ Telematica',45,456);
insert into producto values ('Playera UPQ Automotriz',867,766);

-- Categoria Accesorios--

insert into producto values ('Funda MotoG2',180,4571);
insert into producto values ('Funda MotoG2 plus',190,1000);
insert into producto values ('Funda MotoG3',300,250);
insert into producto values ('Funda MotoG3 plus',200,1564);
insert into producto values ('Funda MotoG4',330,500);
insert into producto values ('Funda MotoG4 plus',500,785);
insert into producto values ('Funda MotoG5',520,4521);
insert into producto values ('Mouse verde',580,4523);
insert into producto values ('Mouse Azul',550,42265);
insert into producto values ('Mouse morado',500,4523);
insert into producto values ('Mouse roto',600,422);
insert into producto values ('Mouse nuevo',600,4226);
insert into producto values ('Mouse usado',700,452);
insert into producto values ('Audifono azules',200,41);
insert into producto values ('Audifono LG Zone',200,14);
insert into producto values ('Audifono LG Magna',100,4000);
insert into producto values ('Audifono LG JOY',100,45);
insert into producto values ('Audifono LG g5',200,4512);
insert into producto values ('Audifono LG flex',200,6);
insert into producto values ('Audifono LG flex 2',800,7552);
insert into producto values ('Audifono Funda LG Q2',200,1512);
insert into producto values ('Funda LG Q3',110,6542);
insert into producto values ('Funda LG Q4',240,612);
insert into producto values ('Audifono LG Q5',600,452);
insert into producto values ('Audifono LG Q6',300,6523);
insert into producto values ('Audifono Samsung S2',400,200);
insert into producto values ('Audifono Samsung S3',480,1542);
insert into producto values ('Audifono Samsung S4',600,563);
insert into producto values ('Audifono Samsung S5',300,3463);
insert into producto values ('Funda Samsung S6',599,35);
insert into producto values ('Funda Samsung S6 plus',799,345);
insert into producto values ('Mica Pantalla Samsung S7',500,56);
insert into producto values ('Mica Pantalla Samsung S7 plus',100,54);
insert into producto values ('Funda Samsung S8',126,15000);
insert into producto values ('Funda Samsung S8 plus ',100,7);
insert into producto values ('Funda Samsung Note 8',299,747);
insert into producto values ('Funda Samsung Note 8 plus',299,554);
insert into producto values ('Mica Pantalla Samsung Ace',100,5);
insert into producto values ('Mica Pantalla Samsung Ace 2',299,4334);
insert into producto values ('Mica Pantalla Samsung GrandPrime',260,4543);

--Categoria Jardín--

insert into producto values ('Semillas Acroclinum',3,343);
insert into producto values ('Semillas Agerato',2,545);
insert into producto values ('Semillas Aguileña',7,4756);
insert into producto values ('Semillas Alegría de la casa',3,75676);
insert into producto values ('Semillas algodón',8,555);
insert into producto values ('Semillas Alhelí Mahón',4,65);
insert into producto values ('Semillas Excelsior',7,6553);
insert into producto values ('Semillas Gigantes',4,7655);
insert into producto values ('Semillas Aliso',8,456);
insert into producto values ('SemillasAmapola ',45,454);
insert into producto values ('Semillas Amaranto',4,569);
insert into producto values ('Semillas cresta',67,97);
insert into producto values ('Semillas Alto flor',6,98);
insert into producto values ('Semillas enano flor',4,682);
insert into producto values ('Semillas Semi variado',1,842);
insert into producto values ('Semillas tapíz magico',7,521);
insert into producto values ('Semillas alpino',5,46);
insert into producto values ('Semillas Begonia',8,322);
insert into producto values ('Semillas cactus',75,65);
insert into producto values ('Semillas calabacita',4,898);
insert into producto values ('Semillas Celéndula',67,678);
insert into producto values ('Semillas campanula',96,67);
insert into producto values ('Semillas capuchina',3,756);
insert into producto values ('Semillas Celosia',8,566);
insert into producto values ('Semillas Centaurea',7,76);
insert into producto values ('Semillas Cineraria',7,5);
insert into producto values ('Semillas clavel',9,5767);
insert into producto values ('Semillas clavelón',57,6576);
insert into producto values ('Semillas de la india',2,56);
insert into producto values ('Semillas Cobea',3,567);
insert into producto values ('Semillas Col Ornamental',3,786);
insert into producto values ('Semillas coleus',7,867);
insert into producto values ('Semillas Cosmos',10,756);
insert into producto values ('Semillas Crisantemo',5,87);
insert into producto values ('Semillas Cyclamen',5,888);
insert into producto values ('Semillas Dalia',69,987);
insert into producto values ('Semillas digitalis',99,78);
insert into producto values ('Semillas Dimorfoteca',57,5867);
insert into producto values ('Semillas Espuela',6,78);
insert into producto values ('Semillas Ficoide',3,566);
insert into producto values ('Semillas flox',7,55);

/*Computadoras*/
insert into producto values ('Acer Aspire E14',8700,100);
insert into producto values ('Acer Aspire E75',9000,130);
insert into producto values ('Acer Aspire E45',7400,120);
insert into producto values ('Acer Aspire E16',8800,100);
insert into producto values ('Acer Aspire N14',4000,1200);
insert into producto values ('Acer Aspire N19',4500,1300);
insert into producto values ('Acer Aspire N34',7000,1200);
insert into producto values ('Acer Aspire N10',3300,110);
insert into producto values ('Acer Aspire G40',4400,1100);
insert into producto values ('Acer Aspire G20',3300,1600);
insert into producto values ('Acer Aspire G70',8900,1300);
insert into producto values ('Asus Serie X',3300,1400);
insert into producto values ('Asus Serie N',7400,120);
insert into producto values ('Asus Serie E',9900,1390);
insert into producto values ('Asus V Series',7800,1900);
insert into producto values ('Asus VivoBook Slim',11900,1300);
insert into producto values ('Asus Serie ZenBook',14000,170);
insert into producto values ('Asus Gaming Series',30000,120);
insert into producto values ('Asus Rog Series',43000,100);
insert into producto values ('Asus Ultra Fine Series',14000,1200);
insert into producto values ('Asus HighTemperature',34000,120);
insert into producto values ('HP Spectre x360 Convertible Laptop',24000,120);
insert into producto values ('HP ENVY x360 Convertible Laptop 15z',28000,90);
insert into producto values ('HP Envy Series',12000,190);
insert into producto values ('HP Spectre Series',14000,170);
insert into producto values ('HP 14T Series',12000,70);
insert into producto values ('HP x360 Series',40000,10);
insert into producto values ('HP Ultralight',7600,100);
insert into producto values ('HP Sensitive S',9000,130);
insert into producto values ('HP Pavillion S',4000,5500);
insert into producto values ('HP UltraSurf Series',8000,1000);
insert into producto values ('Lenovo IdeaPad 310',9000,100);
insert into producto values ('Lenovo 320-14iap',5499,120);
insert into producto values ('Lenovo 320-15ISK',12000,300);
insert into producto values ('Lenovo Yoga Book YB1',13000,3000);
insert into producto values ('Lenovo V110',4300,1000);
insert into producto values ('Lenovo T420',4000,120);
insert into producto values ('Lenovo IP 520s',14999,140);
insert into producto values ('Lenovo ThinkPad',10000,599);
insert into producto values ('Lenovo Idea 310',14999,820);
insert into producto values ('Lenovo Legion Y520',21000,330);

/* Audio y Vídeo */
insert into producto values ('Adaptador RCA a HDMI RadioShack',450,1000);
insert into producto values ('Receptor de Audio y Video Yamaha',15000,100);
insert into producto values ('Splitter 4 Puertos RadioShack',300,1400);
insert into producto values ('Capturadora Audio SVideo Startech',1000,400);
insert into producto values ('Easy Cap Tarjeta Capturadora',110,140);
insert into producto values ('Receptor de Audio DENON',12000,220);
insert into producto values ('Cable Auxiliar RCA Macho',15,4000);
insert into producto values ('HDMI con salida De Audio Optico',700,140);
insert into producto values ('Selector de Señal HDMI Master',220,560);
insert into producto values ('Adaptador Convertidor Señal HDMI RCA',240,10);
insert into producto values ('Audifonos serie ZX',360,1100);
insert into producto values ('Audifonos Sony MDR-ZX',360,5000);
insert into producto values ('Audifonos Extra Bass',750,120);
insert into producto values ('Audifonos para DJ',250,20);
insert into producto values ('Audifonos Bluetooth STF',200,10);
insert into producto values ('Audifonos deportivos Sony MDR',200,1400);
insert into producto values ('Audifonos Stuff Factory',250,1500);
insert into producto values ('Audifonos tipo Monitor Panasonic',400,550);
insert into producto values ('Audifonos on ear Maxell Solid2',300,600);
insert into producto values ('Audifonos Master',149,1000);
insert into producto values ('Canon Camara Digital EOS Rebel',9000,120);
insert into producto values ('Camara Digital Sony',6000,80);
insert into producto values ('Camara Digital SX420',7500,10);
insert into producto values ('Camara Nikon CoolPix',20600,10);
insert into producto values ('Camara Nikon D330',34100,5);
insert into producto values ('Camara Nikon D5500',21000,10);
insert into producto values ('Camara Canon Reflex',12779,10);
insert into producto values ('Camara Canon EOS 5D Mark IV',101150,1);
insert into producto values ('Camara Canon Mark II',51099,1);
insert into producto values ('Camara Canon PowerShot SX60',12700,100);
insert into producto values ('Bocina Logitech 14w',478,100);
insert into producto values ('Bocina Portátil Kaiser',1300,50);
insert into producto values ('Bocina Bafle Kaiser MSA',989,100);
insert into producto values ('Bocina Bluetooth Atvio',150,10);
insert into producto values ('Bocina SoundStream XP',400,600);
insert into producto values ('Bocina Green Leaf',300,890);
insert into producto values ('Bocina Bluetooth Sony',1000,690);
insert into producto values ('Bocina Bafle Atvio',899,600);
insert into producto values ('Bocina Rino 10',1399,40);
insert into producto values ('Bocina JBL Flip 4',2300,200);
insert into producto values ('Bocina Pioneer TSA Dual Via',2100,30);

/*Vinos y Licores*/
insert into producto values ('Tequila Dobel Diamante Reposado 750 Ml',565,100);
insert into producto values ('Tequila Herradura Selección Suprema Extra Añejo 750 Ml',3745,10);
insert into producto values ('Tequila Maestro Tequilero Reposado Clásico 750 Ml',470,100);
insert into producto values ('Tequila Centinela Reposado Clásico 1 L',200,1000);
insert into producto values ('Tequila Corralejo Añejo 750 Ml',435,110);
insert into producto values ('Tequila El Jimador Reposado 950 Ml',185,200);
insert into producto values ('Tequila Los Azulejos Añejo 750 Ml',999,10);
insert into producto values ('Tequila Jarana Auténtico Reposado 1.75 L',160,220);
insert into producto values ('Tequila Corralejo 99 000 Horas Añejo 750 Ml',350,120);
insert into producto values ('Tequila Maestro Tequilero Añejo Clásico 750 Ml',619,420);
insert into producto values ('Vino Serie U Malbec',227,100);
insert into producto values ('Vino Desierto 25 Malbec',605,100);
insert into producto values ('Vino Pérez Pascuas Gran Reserva',9550,1);
insert into producto values ('Vino Pater Cabernet Sauvignon',1550,10);
insert into producto values ('Vino Armonía',165,100);
insert into producto values ('Vino Nudo Merlot',285,110);
insert into producto values ('Vino Malbec Edición limitada',727,10);
insert into producto values ('Vino Ojos Negros Gran Reserva',1028,13);
insert into producto values ('Vino Pinot Noir',599,10);
insert into producto values ('Vino Tabla No. 1 Malbec',472,10);
insert into producto values ('Vodka Grey Goose 750 Ml',640,120);
insert into producto values ('Vodka Gotland 1 L',134,200);
insert into producto values ('Vodka Smirnoff 750 Ml',154,340);
insert into producto values ('Vodka Gotland 750 Ml',145,500);
insert into producto values ('Vodka Wyborowa 1 L',159,20);
insert into producto values ('Vodka Ciroc 750 Ml',619,330);
insert into producto values ('Vodka Tanqueray Sterling 750 Ml',214,15);
insert into producto values ('Vodka Absolut Raspberri 750 Ml',240,12);
insert into producto values ('Vodka Stolichnaya Elit 700 Ml',785,21);
insert into producto values ('Vodka Finlandia 750 Ml',264,65);
insert into producto values ('Brandy De Jerez Gran Duque De Alba Solera Gran Reserva 700 Ml',725,1);
insert into producto values ('Brandy De Jerez Lepanto Solera Gran Reserva 750 Ml',755,10);
insert into producto values ('Brandy De Jerez Carlos I Solera Gran Reserva 700 Ml',750,15);
insert into producto values ('Brandy De Jerez Pedro Domecq Fundador Solera Reserva 700 Ml',169,15);
insert into producto values ('Brandy De Jerez Alma De Magno Solera Gran Reserva 700 Ml',299,21);
insert into producto values ('Brandy De Jerez Carlos Iii Solera Reserva 700 Ml',165,50);
insert into producto values ('Brandy Torres 10 Gran Reserva 1.5 L',659,150);
insert into producto values ('Brandy Torres 15 Reserva Privada 700 Ml',469,150);
insert into producto values ('Brandy De Jerez Cardenal Mendoza Solera Gran Reserva 700 Ml',999,100);
insert into producto values ('Brandy De Jerez Terry 1900 Solera Reserva 700 Ml',359,10);

/* Calzado */
insert into producto values ('Tenis Nike Downshifter 7',1300,20);
insert into producto values ('Tenis Nike Air Versatile',1499,23);
insert into producto values ('Tenis Nike Team Hustle 8',999,43);
insert into producto values ('Tenis Nike Air Presto',1799,15);
insert into producto values ('Tenis Nike Airmax',1994,10);
insert into producto values ('Tenis Nike Tanjun',1749,49);
insert into producto values ('Tenis Nike Roshe One',330,67);
insert into producto values ('Tenis Nike Air Max',345,9);
insert into producto values ('Tenis Nike Air Versitile',899,13);
insert into producto values ('Tenis Nike Air Max Thea',1550,30);
insert into producto values ('Tenis Nike Court Royale',999,76);
insert into producto values ('Tenis Nike Air Max Tavas',1390,65);
insert into producto values ('Tenis Nike Nightgazer',1790,53);
insert into producto values ('Tenis Nike Zoom Train',1799,1);
insert into producto values ('Tenis Nike Air Force',1699,14);
insert into producto values ('Tenis Nike Shox',1499,19);
insert into producto values ('Tenis Nike Retaliation',1499,54);
insert into producto values ('Tenis Nike Sequend',1950,10);
insert into producto values ('Tenis Nike Lunarstelos',1099,69);
insert into producto values ('Tenis Nike Cortez',1799,49);
insert into producto values ('Tenis Converese A',840,205);
insert into producto values ('Tenis Converese B',750,231);
insert into producto values ('Tenis Converese C',480,435);
insert into producto values ('Tenis Converese D',780,158);
insert into producto values ('Tenis Converese E',999,109);
insert into producto values ('Tenis Converese F',480,495);
insert into producto values ('Tenis Converese G',566,676);
insert into producto values ('Tenis Converese H',666,96);
insert into producto values ('Tenis Converese I',777,138);
insert into producto values ('Tenis Converese J',800,309);
insert into producto values ('Tenis Converese K',789,768);
insert into producto values ('Tenis Converese L',750,657);
insert into producto values ('Tenis Converese M',790,538);
insert into producto values ('Tenis Converese N',799,19);
insert into producto values ('Tenis Converese O',699,147);
insert into producto values ('Tenis Converese P',499,199);
insert into producto values ('Tenis Converese Q',499,544);
insert into producto values ('Tenis Converese R',950,106);
insert into producto values ('Tenis Converese X',099,695);
insert into producto values ('Tenis Converese Z',799,494);


---cremas---
insert into producto values ('Crema A',15,4571);
insert into producto values ('Crema B',16,1000);
insert into producto values ('Crema C',16,250);
insert into producto values ('Crema D',14,1564);
insert into producto values ('Crema E',15,500);
insert into producto values ('Crema F',14,785);
insert into producto values ('Crema G',12,4521);
insert into producto values ('Crema H',14,4523);
insert into producto values ('Crema I',12,42265);
insert into producto values ('Crema J',10,4523);
insert into producto values ('Crema K',10,422);
insert into producto values ('Crema L',11,4226);
insert into producto values ('Crema M',12,452);
insert into producto values ('Crema N',12,41);
insert into producto values ('Crema O',17,14);
insert into producto values ('Crema P',12,4000);
insert into producto values ('Crema Q',12,45);
insert into producto values ('Crema R',15,4512);
insert into producto values ('Crema S',17,6);
insert into producto values ('Crema T',17,7552);
insert into producto values ('Crema O',17,1512);
insert into producto values ('Crema V',17,6542);
insert into producto values ('Crema W',18,612);
insert into producto values ('Crema X',12,452);
insert into producto values ('Crema Y',12,6523);
insert into producto values ('Crema X',12,200);
insert into producto values ('Crema XA',15,1542);
insert into producto values ('Crema XB',16,563);
insert into producto values ('Crema XC',16,3463);
insert into producto values ('Crema XD',9,35);
insert into producto values ('Crema XE',15,345);
insert into producto values ('Crema XF',10,56);
insert into producto values ('Crema XG',9,54);
insert into producto values ('Crema XH',9,15000);
insert into producto values ('Crema XI',9,718);
insert into producto values ('Crema XJ',8,747);
insert into producto values ('Crema XK',15,554);
insert into producto values ('Crema XL',14,51756);
insert into producto values ('Crema XM',15,4334);
insert into producto values ('Crema XN',16,4543);

---muebles---
insert into producto values ('Mesa A',750,4571);
insert into producto values ('Mesa B',780,1000);
insert into producto values ('Mesa C',680,250);
insert into producto values ('Mesa D',790,1564);
insert into producto values ('Mesa E',800,500);
insert into producto values ('Mesa F',799,785);
insert into producto values ('Mesa G',540,4521);
insert into producto values ('Mesa H',950,4523);
insert into producto values ('Mesa I',480,42265);
insert into producto values ('Mesa J',777,4523);
insert into producto values ('Silla A',200,422);
insert into producto values ('Silla B',201,4226);
insert into producto values ('Silla C',150,452);
insert into producto values ('Silla D',240,41);
insert into producto values ('Silla E',150,14);
insert into producto values ('Silla F',164,4000);
insert into producto values ('Silla G',147,45);
insert into producto values ('Silla H',159,4512);
insert into producto values ('Silla I',137,6);
insert into producto values ('Silla J',387,7552);
insert into producto values ('Sofa A',2512,1512);
insert into producto values ('Sofa B',2998,6542);
insert into producto values ('Sofa C',3000,612);
insert into producto values ('Sofa D',2486,452);
insert into producto values ('Sofa E',1250,6523);
insert into producto values ('Sofa F',1800,200);
insert into producto values ('Sofa G',500,1542);
insert into producto values ('Sofa H',2480,563);
insert into producto values ('Sofa I',3200,3463);
insert into producto values ('Sofa J',1450,35);
insert into producto values ('Escritorio A',1500,345);
insert into producto values ('Escritorio B',750,56);
insert into producto values ('Escritorio C',800,54);
insert into producto values ('Escritorio D',940,15000);
insert into producto values ('Escritorio E',950,718);
insert into producto values ('Escritorio F',875,747);
insert into producto values ('Escritorio G',1562,554);
insert into producto values ('Escritorio H',1448,51756);
insert into producto values ('Escritorio I',1562,4334);
insert into producto values ('Escritorio J',1614,4543);

--- Zumos y bebidas
insert into producto values ('Boing', 10, 800); 
insert into producto values ('Del Valle', 15, 750);
insert into producto values ('Torres 20', 250, 1500);
insert into producto values ('Bacardi', 210, 1200);
insert into producto values ('Vita coco', 15, 1000);
insert into producto values ('Gazpacho andaluz', 24, 950);
insert into producto values ('Jardin Bio', 42, 610);
insert into producto values ('Punidox', 14, 1340);
insert into producto values ('Jemex', 10, 1201);
insert into producto values ('Zumo mandarina', 16, 940);
insert into producto values ('cafe', 15, 1350);
insert into producto values ('arizona', 10, 1005);
insert into producto values ('Agua ciel', 8, 1200);
insert into producto values ('te negro', 18, 1420);
insert into producto values ('nesquik', 15, 450);
insert into producto values ('Jugo de naranja', 15, 940);
insert into producto values ('Jugo de sandia', 15, 940);
insert into producto values ('Jugo de mango', 15, 940);
insert into producto values ('Jugo de manzana', 15, 940);
insert into producto values ('Jugo de uva', 15, 940);
insert into producto values ('Jugo de guayaba', 15, 940);
insert into producto values ('Jugo de horchata', 15, 940);
insert into producto values ('Jose Cuervo', 250, 1250);
insert into producto values ('Jack Daniels', 300, 1402);
insert into producto values ('Torres 10', 200, 1000);
insert into producto values ('Don Ramon', 180, 1350);
insert into producto values ('Absolut', 310, 950);
insert into producto values ('Epura', 12, 1402);
insert into producto values ('Boing mango', 16, 1210);
insert into producto values ('Piña colada', 20, 1118);
insert into producto values ('Boing mango', 16, 1210);
insert into producto values ('Boing manzana', 16, 1210);
insert into producto values ('Boing limon', 16, 1210);
insert into producto values ('Boing sandia', 16, 1210);
insert into producto values ('Boing tamarindo', 16, 1210);
insert into producto values ('Boing uva', 16, 1210);
insert into producto values ('Boing coco', 16, 1210);
insert into producto values ('Boing guayaba', 16, 1210);
insert into producto values ('Boing horchata', 16, 1210);
insert into producto values ('red bull', 25, 1520);
insert into producto values ('Indio', 14, 850);


--- Aperitivos
insert into producto values ('Sabritas', 14, 790);
insert into producto values ('Sabritas Limon', 14, 790);
insert into producto values ('Sabritas adobadas', 14, 790);
insert into producto values ('Sabritas Clasicas', 14, 790);
insert into producto values ('Rufles sal', 14, 800);
insert into producto values ('Rufles cruch', 14, 800);
insert into producto values ('Rufles queso', 14, 800);
insert into producto values ('Mafer', 20, 750);
insert into producto values ('Rancheritos', 8, 740);
insert into producto values ('Churrumais', 5, 1500);
insert into producto values ('Totopos', 15, 700);
insert into producto values ('Chips pikin', 12, 790);
insert into producto values ('Chips sal', 12, 790);
insert into producto values ('Chips queso', 12, 790);
insert into producto values ('Canapes de anchoa', 17, 840);
insert into producto values ('Canapes con huevos y setas', 17, 840);
insert into producto values ('Canapes de caviar', 17, 840);
insert into producto values ('Canapes de pate de aceitunas', 17, 840);
insert into producto values ('Packetacso', 28, 1120);
insert into producto values ('Doritos Diablo', 12, 700);
insert into producto values ('Doritos Negros', 12, 700);
insert into producto values ('Doritos Pizza', 12, 700);
insert into producto values ('Doritos Nacho', 12, 700);
insert into producto values ('Cacahuates Japoneses', 10, 500);
insert into producto values ('Croquetas de jamon', 25, 840);
insert into producto values ('Croquetas de pollo', 28, 840);
insert into producto values ('Croquetas de soja', 25, 840);
insert into producto values ('Croquetas de carne', 25, 840);
insert into producto values ('Empanada de atun', 30, 550);
insert into producto values ('Empanada de trucha', 30, 550);
insert into producto values ('Empanada frita', 20, 550);
insert into producto values ('Pate de gelatian', 24, 490);
insert into producto values ('Rollitos de pimiento', 14, 300);
insert into producto values ('Rollo delicioso', 14, 550);
insert into producto values ('Torta de papa', 30, 550);
insert into producto values ('Tarta de queso', 45, 670);
insert into producto values ('Tostada media villa', 24, 740);
insert into producto values ('Anchoas al cava', 30, 550);
insert into producto values ('Bolitas de queso', 14, 1002);
insert into producto values ('Deliciosas', 10, 840);

---		Infantil
insert into producto values ('Talco', 15, 250);
insert into producto values ('Gerber', 10, 500);
insert into producto values ('Toallitas humedas', 40, 600);
insert into producto values ('Biberon', 20, 200);
insert into producto values ('Protector para lactancia', 38, 450);
insert into producto values ('Kit para bebe', 1050, 120);
insert into producto values ('Almoadin anti ahogo', 215, 150);
insert into producto values ('Aspirador nasal', 74, 100);
insert into producto values ('Tina para bebes', 599, 149);
insert into producto values ('Corral para bebe', 450, 100);
insert into producto values ('Corral baby zoo', 329, 120);
insert into producto values ('Andadera', 1999, 130);
insert into producto values ('Organizador para bebe', 599, 130);
insert into producto values ('Bañera princel', 299, 60);
insert into producto values ('Cama portatil', 389, 98);
insert into producto values ('Jumper musical', 2499, 149);
insert into producto values ('Pelotero para ni�os', 191, 240);
insert into producto values ('Saco para dormir', 499, 70);
insert into producto values ('Termo para comida', 349, 89);
insert into producto values ('Ba�era cambiador', 1459, 94);
insert into producto values ('Cojines anti caidas', 385, 46);
insert into producto values ('Colchon anti reflujo', 541, 20);
insert into producto values ('Bouncer silla', 690, 45);
insert into producto values ('Cuadros de foamy', 4206, 64);
insert into producto values ('Cama para bebe', 2880, 30);
insert into producto values ('Safety 1st', 399, 80);
insert into producto values ('Libro para colorear', 14, 750);
insert into producto values ('Corral sleep', 1949, 30);
insert into producto values ('Squeeze', 550, 230);
insert into producto values ('Triciclo', 3699, 45);
insert into producto values ('Guats juguete', 549, 84);
insert into producto values ('Brincolin', 899, 49);
insert into producto values ('Andadera', 150, 84);
insert into producto values ('Plato para bebe', 449, 71);
insert into producto values ('Vaso entrenador', 50, 94);
insert into producto values ('Moises para bebe', 3290, 102);
insert into producto values ('Mesa recreativa', 2199, 24);
insert into producto values ('Amiguitos fisher price', 189, 240);
insert into producto values ('Gimnasio para bebe', 1699, 57);
insert into producto values ('Cuchara para bebe', 169, 50);

--- Cuidado personal
insert into producto values ('Pasta Colgate', 45, 720);
insert into producto values ('Advance white', 46, 475);
insert into producto values ('Pasta colgate white', 60, 471);
insert into producto values ('Pasta dental max', 10, 450);
insert into producto values ('Pasta Colgate total', 65, 551);
insert into producto values ('Cortauñas', 10, 420);
insert into producto values ('Jabon Barra', 18, 800);
insert into producto values ('shampoo tresemme', 34, 750);
insert into producto values ('Shampoo Bio expert', 56, 840);
insert into producto values ('Shampoo restarurador', 1538, 200);
insert into producto values ('Shampoo crece-max', 948, 150);
insert into producto values ('Shampoo matizante', 59, 741);
insert into producto values ('Shampoo Tio nacho', 79, 841);
insert into producto values ('Shampoo remedy', 759, 899);
insert into producto values ('Shampoo redken', 304, 687);
insert into producto values ('Listerine Fresh', 42, 680);
insert into producto values ('Acondicionador Tresemme', 62, 125);
insert into producto values ('Acondicionador Citres', 57, 240);
insert into producto values ('Acondicionador dove', 61, 142);
insert into producto values ('Crema vitamina K', 76, 200);
insert into producto values ('Crema novea', 95, 450);
insert into producto values ('Crema Collagenist', 2135, 120);
insert into producto values ('Crema Pons', 56, 461);
insert into producto values ('Crema corporal', 147, 240);
insert into producto values ('Crema acepcia', 75, 240);
insert into producto values ('Talco Rexona', 35, 450);
insert into producto values ('Talco Maja', 77, 650);
insert into producto values ('Silka medic', 35, 473);
insert into producto values ('Talco Walfort', 15, 700);
insert into producto values ('Talco Fresh', 43, 642);
insert into producto values ('Talco amments', 35, 475);
insert into producto values ('Desodorante Botanicus', 90, 240);
insert into producto values ('Desodorante Mitchum', 50, 332);
insert into producto values ('Desodorante nivea', 51, 245);
insert into producto values ('Rastrillo', 20, 462);
insert into producto values ('Cepillo dental Gum', 48, 740);
insert into producto values ('Cepillo dental Equate', 17, 450);
insert into producto values ('Cepillo denta Cool', 14, 652);
insert into producto values ('Cepillo dental Colgate', 61, 120);
insert into producto values ('Cepillo oral B', 45, 478);
insert into producto values ('Cepillo dental Electrico', 200, 341);

---Hogar
insert into producto values ('Clorox', 24, 740);
insert into producto values ('Suaviterl', 24, 720);
insert into producto values ('Ace', 30, 640);
insert into producto values ('Detergente', 30, 650);
insert into producto values ('Mr Limpio', 45, 450);
insert into producto values ('Comedor', 1570, 42);
insert into producto values ('Sillas', 450, 750);
insert into producto values ('Sillones', 3201, 450);
insert into producto values ('Mesa', 750, 125);
insert into producto values ('Florero', 450, 320);
insert into producto values ('Espejo', 1520, 75);
insert into producto values ('Estanteria', 450, 80);
insert into producto values ('Fundas sillones', 70, 140);
insert into producto values ('Colchon', 1200, 300);
insert into producto values ('Hedredon', 340, 756);
insert into producto values ('Ganchos', 56, 750);
insert into producto values ('Escoba', 30, 485);
insert into producto values ('Trapeador', 32, 653);
insert into producto values ('Recogedor', 24, 754);
insert into producto values ('Fundas colchon', 94, 972);
insert into producto values ('Aromatizante', 32, 641);
insert into producto values ('Foco', 14, 743);
insert into producto values ('Porta Retrato', 237, 260);
insert into producto values ('Licuadora', 750, 463);
insert into producto values ('Micro ondas', 1521, 346);
insert into producto values ('Bocinas', 3402, 540);
insert into producto values ('Macetero', 81, 350);
insert into producto values ('Puerta', 1000, 480);
insert into producto values ('Alfonbra', 480, 190);
insert into producto values ('Cojines', 150, 433);
insert into producto values ('Almohadas', 320, 777);
insert into producto values ('Closet', 3460, 30);
insert into producto values ('Retretes', 759, 20);
insert into producto values ('Timbre', 99, 191);
insert into producto values ('Chapa para puesta', 250, 369);
insert into producto values ('Escritorio', 1210, 619);
insert into producto values ('Soporte para television', 340, 115);
insert into producto values ('Refrigerador', 3480, 321);
insert into producto values ('Lavadora', 4000, 167);
insert into producto values ('Telefono de casa', 159, 241);

--- carnes
insert into producto values ('Guten', 56, 900);
insert into producto values ('Jamon Pavo', 45, 800);
insert into producto values ('Salchicha Americana', 33, 758);
insert into producto values ('Milenasa', 120, 1500);
insert into producto values ('Jamon de Res',45 ,500 );
insert into producto values ('Pechuga pollo con hueso',74 ,4500 );
insert into producto values ('Pechuga de pollo sin hueso',89 ,500 );
insert into producto values ('Pierna de pavo',72 ,140 );
insert into producto values ('Pollo completo',90 ,673 );
insert into producto values ('Medio pollo',45, 740);
insert into producto values ('Barbacoa',250 ,95 );
insert into producto values ('Muslo ',87 ,400 );
insert into producto values ('Salchicha de pavo',23 ,700);
insert into producto values ('Salchicha de res',65 ,500 );
insert into producto values ('Pierna de puerco', 85,452 );
insert into producto values ('Costilla', 78,120 );
insert into producto values ('Cabeza de Puerco',69 , 700);
insert into producto values ('Pansa',150 ,950 );
insert into producto values ('Lomo', 61,473);
insert into producto values ('Cecina',45 ,700 );
insert into producto values ('Conejo', 95, 100);
insert into producto values ('Cordero', 245,9 );
insert into producto values ('Ternera', 88,451 );
insert into producto values ('Pato',96 ,555 );
insert into producto values ('Ganso',89 ,745 );
insert into producto values ('Tocino',22 ,452 );
insert into producto values ('Chorizo de res',45 ,756 );
insert into producto values ('Chorizo de pavo',23 ,400 );
insert into producto values ('Chuleta',74 ,200 );
insert into producto values ('Falda',65 ,743 );
insert into producto values ('Carne molida',54 ,600 );
insert into producto values ('Pescado',34 ,126 );
insert into producto values ('Fish',45 ,562 );
insert into producto values ('Chiken empanizado',52 ,459 );
insert into producto values ('Duck empanizado', 45, 852);
insert into producto values ('Conejo empanizado',78 ,123 );
insert into producto values ('Chuletas de res', 45, 655);
insert into producto values ('Pollo empanizado',75 ,426 );
insert into producto values ('Jamon empanizado',23,756 );
insert into producto values ('Pescado empanizado', 65, 801);





--- frutas y verduras
insert into producto values ('Manzana', 47, 450);
insert into producto values ('Platana', 54, 700);
insert into producto values ('Sandia', 37, 1500);
insert into producto values ('Pera', 25, 840);
insert into producto values ('Aguacate',55521 ,1200 );
insert into producto values ('Arandano', 45,141 );
insert into producto values ('Cereza',45 ,965 );
insert into producto values ('Ciruela',78 ,745 );
insert into producto values ('Coco',12 ,452 );
insert into producto values ('Frambuesa',75 ,129 );
insert into producto values ('Fresa', 86,753 );
insert into producto values ('Granada',65 ,761 );
insert into producto values ('Higo',21 , 459);
insert into producto values ('Kiwi', 64, 159);
insert into producto values ('Lima', 63, 753);
insert into producto values ('Limon', 65,419 );
insert into producto values ('Mango',98 ,953 );
insert into producto values ('Manzana roja', 23,492 );
insert into producto values ('Maracuya', 57,252 );
insert into producto values ('Melocoton',36 , 746);
insert into producto values ('Membrillo',37 ,753 );
insert into producto values ('Zarzamora', 35,576);
insert into producto values ('Naranja', 54, 342);
insert into producto values ('piña', 65,273 );
insert into producto values ('Toronja',97 ,238 );
insert into producto values ('Uva verde',46 ,853 );
insert into producto values ('Uva morda',46 ,975 );
insert into producto values ('Uva sin hueso', 25,362 );
insert into producto values ('Cebolla', 22,754 );
insert into producto values ('Calabaza', 36,654 );
insert into producto values ('Jitomate', 25,246 );
insert into producto values ('Tomate verde', 23,368 );
insert into producto values ('Apio',23 ,456 );
insert into producto values ('Peregil', 29, 457);
insert into producto values ('Cilantro',12 ,598 );
insert into producto values ('Chile pimiento', 04,753 );
insert into producto values ('Chile manzano',10 , 564);
insert into producto values ('Chile verde', 20,645 );
insert into producto values ('Chile pasilla', 16, 453);
insert into producto values ('Chile rojo', 07,375 );

--- Panaderia y dulces

insert into producto values ('Bimbo', 30, 600);
insert into producto values ('Concha fresa', 6, 300);
insert into producto values ('Panque', 8, 300);
insert into producto values ('Telera', 3, 500);
insert into producto values ('Concha Vainilla',12,343);
insert into producto values ('Concha chocolate',4 ,654);
insert into producto values ('Dona fresa', 5,456);
insert into producto values ('Dona chocolate', 2, 242);
insert into producto values ('dona Cafe', 5,343);
insert into producto values ('dona azucar', 5,242);
insert into producto values ('Bimbo integral', 5,435);
insert into producto values ('Paleta chile', 2,435);
insert into producto values ('Chicles fresa',3 ,234);
insert into producto values ('Chicles Uva', 3,454);
insert into producto values ('Telera grande', 3,677);
insert into producto values ('Telera Chica', 3,657);
insert into producto values ('Panque chocolate', 12,345);
insert into producto values ('Oreja', 12,445);
insert into producto values ('Duvalin', 4,544);
insert into producto values ('Mamut', 4,6575);
insert into producto values ('Kinder Delice',15,242);
insert into producto values ('Ferrero ',7 ,234);
insert into producto values ('Mazapan', 4,567);
insert into producto values ('Ricaleta', 2,345);
insert into producto values ('Crayon', 3,456);
insert into producto values ('Bocadin', 6,456);
insert into producto values ('Jelly Bob Esponja',8 ,345);
insert into producto values ('Jelly beans', 6,435);
insert into producto values ('Tutsi pop',3 ,853);
insert into producto values ('Manchitas', 6,346);
insert into producto values ('Tix tix', 23,435);
insert into producto values ('Risnadas', 3,5334);
insert into producto values ('Tama-roca',4 ,754);
insert into producto values ('Rocaleta', 3,4353);
insert into producto values ('Totis', 5,564);
insert into producto values ('Bubalo', 2,785);
insert into producto values ('Chocolate amargo',3 ,6554);
insert into producto values ('Chcolote blanco',4 ,567);
insert into producto values ('Miguelito', 3,456);
insert into producto values ('Mangomis', 7,354);

--- Huevos lacteos y cafe
insert into producto values ('Leche Queretaro', 15, 100);
insert into producto values ('Cafe Legal', 5, 580);
insert into producto values ('Nescafe', 15, 620);
insert into producto values ('Nutri Leche', 11, 450);
insert into producto values ('Huevo',32 ,234 );
insert into producto values ('Cafe frio', 23,342 );
insert into producto values ('yogurt fresa', 23,543 );
insert into producto values ('yogurt chocolate', 23,435 );
insert into producto values ('yogurt piña',12 ,465 );
insert into producto values ('yogurt manzana', 34,2344 );
insert into producto values ('yogurt Natural', 23,765 );
insert into producto values ('cafe molido', 21, 635);
insert into producto values ('Leche Cholate',12 ,344 );
insert into producto values ('Leche vainilla', 32, 445);
insert into producto values ('Leche fresa',12 ,345 );
insert into producto values ('Danette Vainilla', 21, 344);
insert into producto values ('Danette Chocolate', 12, 435);
insert into producto values ('Daninino',4 ,232 );
insert into producto values ('Yomi ', 2,233 );
insert into producto values ('Yakult', 7, 234);
insert into producto values ('Crema natural lala',32 , 1235);
insert into producto values ('Crema alpura', 22,122 );
insert into producto values ('Crema para batir', 24, 322);
insert into producto values ('Lechera', 12, 346);
insert into producto values ('Carnation', 12,654 );
insert into producto values ('Queso Ranchero',23 ,6865 );
insert into producto values ('Queso Oaxaca', 23,357 );
insert into producto values ('Queso la vaquita', 21,435 );
insert into producto values ('Huevo la campanita', 56,543 );
insert into producto values ('Huevo la casa dorada', 23, 865);
insert into producto values ('yogurt piña-freson',32 ,2342 );
insert into producto values ('yogurt choco-banana', 32, 433);
insert into producto values ('Leche lala', 12, 434);
insert into producto values ('Leche alpura',12 ,324 );
insert into producto values ('Lecha las 3 vaquitas',12 , 654);
insert into producto values ('Cafe en grano',12 ,4564 );
insert into producto values ('Queso Coronel',43 , 323);
insert into producto values ('Leche evaporada', 23,765 );
insert into producto values ('yogurt natural la vaquita',23 , 456);
insert into producto values ('yogurt uva', 22, 324);

--- Aceite, Pastas Legumbres
insert into producto values ('Frijol Rojo', 22, 580);
insert into producto values ('Nutrioli', 15, 450);
insert into producto values ('1-2-3', 10, 450);
insert into producto values ('Frijol Negro', 30, 580);
insert into producto values ('Frijol verde',12 ,534 );
insert into producto values ('Frijol azul',21 ,234 );
insert into producto values ('Frijol morado',12 ,345 );
insert into producto values ('Frijol narnaja', 31, 234);
insert into producto values ('Frijol ranchero ',54 ,768 );
insert into producto values ('Aceite Vegetal', 44, 657);
insert into producto values ('Maruchan',34 ,546 );
insert into producto values ('Arroz',23 ,546 );
insert into producto values ('Pasas', 23,435 );
insert into producto values ('Sopa palitos', 12, 234);
insert into producto values ('Sopa bilitas',12 ,4645 );
insert into producto values ('Sopa letras', 11,234 );
insert into producto values ('Sopa Codito grande',26 ,435 );
insert into producto values ('Sopa Codito mediano',42 ,212 );
insert into producto values ('Sopa Codito chico',11 ,234 );
insert into producto values ('Spagueti', 7,112 );
insert into producto values ('Ramen', 2,675 );
insert into producto values ('Frijos de soya',12 ,476 );
insert into producto values ('Cacahuate', 22,467 );
insert into producto values ('Marucha camaron', 23,937 );
insert into producto values ('Maruchan pollo',23 ,654 );
insert into producto values ('Maruchan chile',19 ,254 );
insert into producto values ('Aceite de Oliva',16 , 352);
insert into producto values ('Sopa galets',4 ,466 );
insert into producto values ('Alubias',23 ,775 );
insert into producto values ('Fideos', 23, 987);
insert into producto values ('Champiñones', 23, 98);
insert into producto values ('Nissin de pollo',5, 353);
insert into producto values ('Nissin de tocino',34 ,3445 );
insert into producto values ('Nissin de camaron', 23,665 );
insert into producto values ('Italpasta', 23, 634);
insert into producto values ('La moderna', 12, 433);
insert into producto values ('Ottogi de pollo',11,743 );
insert into producto values ('Ottogi de camaron',11 ,233 );
insert into producto values ('Ottogi de Chile', 11,752 );
insert into producto values ('Fideos grandes',16 ,234 );


/****************************************************************inserts blancos******************************************************************/
insert into producto values ('Samsung - Lavadora Samsung WA17F7L2UDW 17',4500,1300);
insert into producto values ('Refrigerador 26 Pies Ge Con Despachador Silver',7000,1200);
insert into producto values ('Lavadora Mabe 18 Kg Blanca',3300,110);
insert into producto values ('IEM - Estufa De Piso Iem 20" Color Blanca',4400,1100);
insert into producto values ('Campana Mabe De 76 Cm Blanca Mod. Cm7641b',3300,1600);
insert into producto values ('Lavadora Whirlpool 18 Kg Blanca',8900,1300);
insert into producto values ('T-Fal Procesador de Alimentos Pica Lica19 x 37 30 cm',3300,1400);
insert into producto values ('Dace - Lavadora Manual Dace 10 Kgs. Modelo LA11101 - Blanco',7400,120);
insert into producto values ('Lavadora Samsung 19 Kg Blanca',9900,1390);
insert into producto values ('Mabe - Estufa Mabe 30" Mod.Em7620bapb0 Blanca',7800,1900);
insert into producto values ('Lavadora Mabe 20 Kg Blanca',11900,1300);
insert into producto values ('Regulador Koblenz Para Línea Blanca 2500 Va Mod. Ri-2502',14000,170);
insert into producto values ('Lavadora Samsung 17 Kg Blanca',30000,120);
insert into producto values ('Mabe - Refrigerador RMA1025VMXB Blanco 2 Ptas Mabe 10 Pies Cúbicos',43000,100);
insert into producto values ('Lavadora Mabe 22 Kg Blanca',14000,1200);
insert into producto values ('Refrigerador 19 Pies Mabe Con Despachador Acero Inox',34000,120);
insert into producto values ('Parrilla De Inducción Turmix Mod. Tu79 Negra',24000,120);
insert into producto values ('Teka - Campana Empotrable Teka C810',28000,90);
insert into producto values ('Estufa Mabe 30" Silver',12000,190);
insert into producto values ('Horno de Microondas Daewoo 0.7 Pies KOR-662M - Blanco',14000,170);
insert into producto values ('Lavadora Mabe 22 Kg Blanca',12000,70);
insert into producto values ('Lavadora Daewoo 18 Kg DG361AWW3 - Blanco',40000,10);
insert into producto values ('Koblenz Centrifugadora 5 Kg SCK55 - Blanco/Vino',7600,100);
insert into producto values ('Teka - Campana Empotrable Teka C810',9000,130);
insert into producto values ('Easy Lavadora 2 tinas 13 Kg LED1344B1 - Blanco',4000,5500);
insert into producto values ('Refrigerador 14 Pies Mabe Con Despachador Silver',8000,1000);
insert into producto values ('LG - Lavadora 19 Kg Smart Inverter Marca LG WT19DSB-SILVER',9000,100);
insert into producto values ('Acros - Estufa de Piso Acros 20 Pulgadas o 51 Cms. Modelo AW-5400D - Plata',5499,120);
insert into producto values ('Samsung - Lavadora Samsung WA17F7L2UDW 17 KG-Blanco',12000,300);
insert into producto values ('Lavadora Automática Whirlpool 7MWTW9919DM 19 Kg Xpert System-Blanca',13000,3000);
insert into producto values ('Refrigerador 11 Pies Lg Con Despachador Silver',4300,1000);
insert into producto values ('Parrilla A Gas Mabe Negra',4000,120);
insert into producto values ('Refrigerador 12 Pies Samsung Con Despachador Silver',14999,140);
insert into producto values ('Acros Estufa de Piso 30” AF5432D - Titanio',10000,599);
insert into producto values ('Refrigerador Acros 7 Pies Cúbicos AS7606F',14999,820);

/*******************************************************************inserts videojuegos*******************************************************************/
insert into producto values ('Consola De Videojuegos Atari Flashback 8',565,100);
insert into producto values ('999 Vídeo Juegos Arcada Consola De La Máquina Doble Palanc',3745,10);
insert into producto values ('Videojuego Crash N. Sane Trilogy Para Xbox One',470,100);
insert into producto values ('mini consola de juegos de mano joystick arcade integrado en el clásico reproductor de videojuegos 108',900,1000);
insert into producto values ('Consola Xbox One S 500 GB + Videojuego Madden 18',4335,110);
insert into producto values ('Consola Xbox One S 1TB + Videojuego Forza Horizon 3',185,5900);
insert into producto values ('Consola PS4 Hits Bundle 500 GB + 3 Videojuegos Físicos',7999,10);
insert into producto values ('Xbox One Dragon ball fighterz one para xbox one',1600,220);
insert into producto values ('Forza Motorspot 7 Ultimate Edition Xbox One',2350,120);
insert into producto values ('Super Mario Maker Nintendo 3DS',1019,420);
insert into producto values ('Crash Bandicoot N Sane Trilogy PS4',799,100);
insert into producto values ('Minecraft New Nintendo 3DS Edition',795,100);
insert into producto values ('Consola Nintendo Switch Neon',9550,1);
insert into producto values ('Assassins Creed: Origins PS4',1550,10);
insert into producto values ('Forza Horizon 3 Xbox One',665,100);
insert into producto values ('Consola Atari Flashback 8 Gold',1285,110);
insert into producto values ('Pubg Xbox One',397,10);
insert into producto values ('Disneyland Adventures Xbox One',1028,13);
insert into producto values ('Rime Xbox One',599,10);
insert into producto values ('Just Dance 2017 Nintendo Switch',472,10);
insert into producto values ('Minecraft Explorers Pack Xbox One',640,120);
insert into producto values ('Rush Hd Xbox One',134,200);
insert into producto values ('Consola Retro Tipo Nintendo Nes 620 Juegos Clasicos - Te1224',699,340);
insert into producto values ('Consola Xbox One S 500 GB + Videojuego Pro Evolution Soccer 2018',5145,500);
insert into producto values ('Grand Theft Auto V Gta 5 Gta V Para Xbox One Nuevo Fisico',899,20);
insert into producto values ('Grand Theft Auto San Andreas Xbox 360',619,330);
insert into producto values ('Mario Kart 8 Nintendo Wii U',214,15);
insert into producto values ('Just Dance 2018 Xbox One',240,12);
insert into producto values ('Lego Marvel Super Heroes 2 Xbox One',785,21);
insert into producto values ('Consola De Videojuegos Atom-x 47 Juegos De Nes - Te1096',264,65);
insert into producto values ('Dead Rising 4 Xbox One',725,1);
insert into producto values ('Lego City Undercover Xbox One',755,10);
insert into producto values ('Batman Telltale 2 Xbox One',750,15);
insert into producto values ('Killer Instinct Definitive Edition Xbox One',169,15);
insert into producto values ('Consola Playstation 4 1tb Más Videojuego Fifa 18',7999,21);
insert into producto values ('Consola PS4 1TB + Videojuego FIFA 18',8965,50);
insert into producto values ('Shadow Of War Xbox One',659,150);
insert into producto values ('Xbox one audifono estereo blanco',469,150);
insert into producto values ('Consola Xbox One S 500gb Pro Evolution Soccer 2018l',7999,100);
insert into producto values ('Consola Xbox One X 1tb Negra',10999,10);

-------------------------------------------------------------------------inserts papeleria-------------------------------------------------------------------------
insert into producto values ('Papel reciclado negro con 100 Hojas',55 ,115 );
insert into producto values ('Papel reciclado rojo con 100 Hojas',55 , 115 );
insert into producto values ('Hojas cappuccino 100 carta',23 ,115 );
insert into producto values ('Papel Copy paper',675 ,400 );
insert into producto values ('Papel autoaherible colores',77.90 ,4597 );
insert into producto values ('Resma c/750 hojas',120 ,4197 );
insert into producto values ('Papel fotografico ',124.90 ,1250 );
insert into producto values ('Papel de color Pochteca Brights',78 ,1100 );
insert into producto values ('Papel texturizado Pochteca Parchment',103 ,1100); 
insert into producto values ('Acetato p/impresora AOD-LASER',139 ,2909 );
insert into producto values ('Papel de color Porchteca Pastel ',72 ,4512 );
insert into producto values ('Papel texturizado Pochteca Ambassador',199 ,41 );
insert into producto values ('Papel colores pastel',46 ,4312 );
insert into producto values ('Resma Papel reciclado',63.75 ,4476 );
insert into producto values ('Resma Papel 75 Gr Carta',75 ,4598 );
insert into producto values ('Papel Opalina Pochteca rombos',140 ,4697 );
insert into producto values ('Rollo para sumadora',90 ,797 );
insert into producto values ('Cartulina fluorescente',52 ,15248 );
insert into producto values ('Cartulina fashion',15 ,654 );
insert into producto values ('Papel china c/3 pliegos',10 ,4597 );
insert into producto values ('Papel crepe c/2 pliegos',14 ,1549 );
insert into producto values ('Cartulina Opalina blanca',170 ,5181 );
insert into producto values ('Lapicera de plastico',49 ,5492 );
insert into producto values ('Goma clic eraser II tipo lapiz pentel',115 ,4585);
insert into producto values ('Papel kraft p/empaque rollo de 76X4.5 M',26.90 ,6542 );
insert into producto values ('Goma pentel Hi-polymer profesional',45 ,7592 );
insert into producto values ('Pluma multiusos staedtler paquete c/4 piezas',199 ,456 );
insert into producto values ('Pluma red retractil zebra z-grip colores', 89, 4586);
insert into producto values ('Carpeta carta firma azul c/100 piezas',199 ,4558 );
insert into producto values ('Calculadora basica canon',129 ,4587 );
insert into producto values ('Carpeta colgante carta oficina',165 ,5458 );
insert into producto values ('Quitagrapas maped colores surtidos',10.90 ,45 );
insert into producto values ('Pluma bic presion y suavidad negro 12 piezas', 59,4510 );
insert into producto values ('Pluma bic presion y suavidad azul 12 piezas',59 ,458 );
insert into producto values ('Cutter d eplastico mapeado',15.50 ,7525 );
insert into producto values ('Agenda perpetua urbana',105 ,1251 );
insert into producto values ('Losetas de corcho alfra',227 ,4521 );
insert into producto values ('Post-it minicubo 2x2 neon 400 hojas',48.50 ,4582 );
insert into producto values ('Carpeta de broche informe cardenal',22.90 ,45221 );
insert into producto values ('Marcador sharpie permanente metalico 1 pieza',22.50 ,125 );


---------------------------------------------------------------------35 Inserts perfumeria-------------------------------------------------------------------
insert into producto values ('Agua El Loewe',1750,505);
insert into producto values ('Agua fresca Azahar Edt',580,433);
insert into producto values ('Aura floral Loewe',1610,354);
insert into producto values ('Bambu cofre edt 120+ shower gel',450,345);
insert into producto values ('I love y/tonight',1740,323);
insert into producto values ('Solo loewe',2550,364);
insert into producto values ('Solo Cedro loewe',1700,463);
insert into producto values ('212 NYC EDT Carolina Herrera',1305,150);
insert into producto values ('212 NYC Men Cofre EDT 100ml Carolina Herrera',214,325);
insert into producto values ('212 NYC MEN EDT Carolina Herrera',1835,175);
insert into producto values ('212 SEXI EDP Carolina Herrera',1910,180);
insert into producto values ('212 SEXI MEN EDT Carolina Herrera',1825,225);
insert into producto values ('Acqua di colbert edt x 100ml',195,445);
insert into producto values ('Acqua di gio homme Giorgio Armani',1790,464);
insert into producto values ('Acqua di gio homme essenza Giorgio Armani',2290,54);
insert into producto values ('Acqua di gioia',1590,75);
insert into producto values ('Agua ella Loewe',1750,566);
insert into producto values ('Aim high EDT',434.50,567);
insert into producto values ('Altai just love EDP',480,454);
insert into producto values ('Altai kiss me EDP',460,444);
insert into producto values ('Altai red lady EDP',440,685);
insert into producto values ('Amor Amor Cacharel',999,457);
insert into producto values ('Amarige EDT Givenchy',1420,75);
insert into producto values ('Boss Bottled men cofre EDT 100ml',1990,156);
insert into producto values ('Boss the scent cofre EDT 100ml',2190,7953);
insert into producto values ('Dance EDT Shakira',450,467);
insert into producto values ('Elixir EDT Shakira',384,457);
insert into producto values ('I AM ROCK Shakira',450,7885);
insert into producto values ('Laguna EDT Salvador Dali',399,645);
insert into producto values ('CK OBSESSED MEN EDP Calvin Klein',1400,665);
insert into producto values ('CK OBSESSED WOM EDP Calvin Klein',1600,856);
insert into producto values ('CK ONE GOLD EDT Calvin Klein',1390,600);
insert into producto values ('CK ONE SUMMER EDT Calvin Klein',990,87);
insert into producto values ('ETHERNITY NOW MEN EDT Calvin Klein',950,67);
insert into producto values ('Forever Boss',550,454);

	---------------------------------------------------------------------- 40 inserts Mascotas-----------------------------------------------------------------------
insert into producto values ('Entrenador para perro',45 ,115 );
insert into producto values ('Entrenador para gato',41 ,2000 );
insert into producto values ('DogShow Cachorro 4KG',85 ,5510 );
insert into producto values ('DogShow Cachorro 10KG',245 ,400 );
insert into producto values ('DogShow Adulto 4KG',107 ,4597 );
insert into producto values ('DogShow Adulto 10KG',500 ,4197 );
insert into producto values ('whiskas Cachorro 4KG',84 ,1211 );
insert into producto values ('whiskas Adulto 4KG',106 ,1526 );
insert into producto values ('whiskas Cachorro 10KG',647 ,4597 );
insert into producto values ('whiskas Adulto 10KG',410 ,4474 );
insert into producto values ('Atomizador para perro',150 ,4512 );
insert into producto values ('Atomizador para Gato',120 ,41 );
insert into producto values ('shampoo perro cachorro',99 ,4582 );
insert into producto values ('shampoo perro Adulto',165 ,4 );
insert into producto values ('shampoo gato cachorro',145 ,4598 );
insert into producto values ('shampoo gato Adulto',199 ,45 );
insert into producto values ('Perfume perro cachorro',255 ,15478 );
insert into producto values ('Perfume perro Adulto',255 ,15248 );
insert into producto values ('Perfume gato Cachorro',125 ,654 );
insert into producto values ('Perfume gato Adulto',198 ,4597 );
insert into producto values ('Pelota perro azul',45 ,1549 );
insert into producto values ('Pelota perro Roja',45 ,5181 );
insert into producto values ('Pelota perro tela',85 ,5492 );
insert into producto values ('Pelota perro Morada',45 ,4585);
insert into producto values ('Peluche gato azul',71 ,6542 );
insert into producto values ('Peluche gato morado',45 ,7592 );
insert into producto values ('Peluche gato rojo',72 ,456 );
insert into producto values ('Hueso perro Cachorro', 13, 4586);
insert into producto values ('Hueso perro Adulto',25 ,4558 );
insert into producto values ('Premio perro Cachorro',62 ,4587 );
insert into producto values ('Premio perro Adulto',81 ,5458 );
insert into producto values ('Premio gato Cachorro',99 ,45 );
insert into producto values ('Premio gato Adulto', 205,4510 );
insert into producto values ('Sueter perro Azul',350 ,458 );
insert into producto values ('Sueter perro Amarillo',545 ,7525 );
insert into producto values ('Sueter perro Colores',522 ,1251 );
insert into producto values ('Sueter Gato Morado',227 ,4521 );
insert into producto values ('Sueter Gato Naranja',457 ,4582 );
insert into producto values ('Sueter Gato Azul',455 ,45221 );
insert into producto values ('Sueter Gato Rojo',455 ,125 );


-------------------------------------------------------------------------35 Inserts Limpieza-------------------------------------------------------------------------
insert into producto values ('Abrillantador',22,545);
insert into producto values ('Detergente',43,4334);
insert into producto values ('Solución MAX',34,354);
insert into producto values ('LimpiaFacil',45,345);
insert into producto values ('LimpiaEsta',26,323);
insert into producto values ('LimpiaLaotra',34,364);
insert into producto values ('Trapeador',73,463);
insert into producto values ('Escoba azul',34,6);
insert into producto values ('Escoba Verde',34,555);
insert into producto values ('Escoba ultrasonica',1000,1);
insert into producto values ('Trapeador Volador',5700,8);
insert into producto values ('Franela Azul',34,866);
insert into producto values ('Franela Verde',23,445);
insert into producto values ('Brasso Uva',23,4645);
insert into producto values ('Brasso Manzana',27,5442);
insert into producto values ('Brasso Pera',56,75);
insert into producto values ('Brasso Caro',65,566);
insert into producto values ('Brasso Bueno',75,567);
insert into producto values ('Brasso roto ',48,4544);
insert into producto values ('Salvo me Salva',46,4444);
insert into producto values ('Salvo me ayuda',54,685);
insert into producto values ('Salvo no me salva',35,457);
insert into producto values ('Salvo no me quiere',25,7);
insert into producto values ('Salvo azul',35,9242);
insert into producto values ('Salvo verde :v',54,7953);
insert into producto values ('Jabón-Zote',45,467);
insert into producto values ('Jabón para manos',84,45745);
insert into producto values ('Jabón para muebles',45,7885);
insert into producto values ('Cloro ropa',34,6455);
insert into producto values ('Cloro blanco',34,665);
insert into producto values ('Cloralex',45,856);
insert into producto values ('Pinol',45,9600);
insert into producto values ('Pato',34,8776);
insert into producto values ('Axion',23,67445);
insert into producto values ('Axion max',17,454);

---------------------------------------------------------------------------ferrereria---------------------------------------------------------------------------
insert into producto values ('Faros de auto',76,149);
insert into producto values ('Jabon Aromatizante',68,138);
insert into producto values ('agua de rosas limpieza',99,342);
insert into producto values ('tapetes para auto marca rosa',76,49);
insert into producto values ('paquete de fundas',59,36);
insert into producto values ('llavero de carrito',50,6);
insert into producto values ('juego de dados',73,116);
insert into producto values ('shampoo marca frigo',79,378);
insert into producto values ('Karcher ',68,0);
insert into producto values ('manguera para karcher',61,489);
insert into producto values ('llave para karcher',85,37);
insert into producto values ('cuerda para karcher',33,202);
insert into producto values ('estropajo para  karcher',35,253);
insert into producto values ('la karcher',85,353);
insert into producto values ('refaccion faro',66,342);
insert into producto values ('refaccion   llantas',55,491);
insert into producto values ('rin 13',97,145);
insert into producto values ('rin 14',37,329);
insert into producto values ('rin 15',38,138);
insert into producto values ('rin 16',51,401);
insert into producto values ('rin 18',72,42);
insert into producto values ('rin 20',87,463);
insert into producto values ('llavero para mono',45,123);
insert into producto values ('espejo de auto',59,131);
insert into producto values ('espejo lateral izquierdo',71,399);
insert into producto values ('espejo lateral derecho',41,167);
insert into producto values ('jabon para tapete',89,331);
insert into producto values ('esponja limpiadora',78,17);
insert into producto values ('shampo marca karcher',56,202);
insert into producto values ('galletas para auto',60,200);
insert into producto values ('correa para auto',52,396);
insert into producto values ('destornillador',60,120);
insert into producto values ('desarmador',52,459);
insert into producto values ('llaves españolas 1/32',68,360);
insert into producto values ('llave para mano',88,212);
insert into producto values ('llave de perro',79,176);
insert into producto values ('desarmador 1',84,309);
insert into producto values ('desarmador 2',93,433);
insert into producto values ('desarmador 3',48,171);
insert into producto values ('desarmador 4',52,433);
insert into producto values ('tarjeta de desarmadores',76,32);
insert into producto values ('tijeras para llanta',34,444);
insert into producto values ('caja herramienta 1',81,121);
insert into producto values ('caja herramienta 2',54,263);
insert into producto values ('clavos diferentes tamaños',72,465);
insert into producto values ('pastillas de limpieza',26,467);
insert into producto values ('llave marca allison',95,466);
insert into producto values ('llave marca panda',31,483);
insert into producto values ('llave de mano marca insite',99,344);
insert into producto values ('desarmador marca don',78,320);
insert into producto values ('desarmador marca insite',30,113);
insert into producto values ('destornillador marca don',80,62);
insert into producto values ('pollo frito figurita',87,391);
insert into producto values ('tenis figurita',91,139);
insert into producto values ('licuadora  para auto',83,392);
insert into producto values ('bomba del agua',60,385);
insert into producto values ('braquets para auto',77,470);
insert into producto values ('bomba de agua marca don',36,65);
insert into producto values ('cargador de auto',50,374);
insert into producto values ('super cargador de auto',83,166);

------------------------------------------------------------------------------marca propia------------------------------------------------------------------------------
insert into producto values ('pasta de dientes Marca Locide',55,391);
insert into producto values ('Crema de vaca Marca Locide',33,469);
insert into producto values ('Fruta Natural Marca Locide',43,61);
insert into producto values ('Audifonos Marca Locide',24,101);
insert into producto values ('Paquete de Salmon Marca Locide',19,140);
insert into producto values ('Perfume 1232 Marca Locide',12,429);
insert into producto values ('Escoba  Marca Locide',56,308);
insert into producto values ('1 kg de tortilla Marca Locide',45,312);
insert into producto values ('Maiz Palomero Marca Locide',36,397);
insert into producto values ('Jabon Corporal Marca Locide',32,8);
insert into producto values ('Paquete coco rallado Marca Locide',27,311);
insert into producto values ('Licuadora JFN32 Marca Locide',27,112);
insert into producto values ('Teclado Computadora Marca Locide',16,121);
insert into producto values ('Pastillas Anticonceptivas Marca Locide',38,319);
insert into producto values ('Carrito de Juguete Marca Locide',24,96);
insert into producto values ('Llavero de perrito Marca Locide',23,222);
insert into producto values ('Planta artificial Marca Locide',14,92);
insert into producto values ('Cereal de trigo Marca Locide',32,58);
insert into producto values ('Cereal de maiz Marca Locide',55,243);
insert into producto values ('Cereal de perro Marca Locide',14,304);
insert into producto values ('Mouse computadora Marca Locide',30,14);
insert into producto values ('Aceite de Oliva Marca Locide',21,199);
insert into producto values ('Aceite de burro Marca Locide',25,279);
insert into producto values ('Crema de puerco Marca Locide',49,433);
insert into producto values ('Crema de nuez Marca Locide',27,348);
insert into producto values ('leche de nuez Marca Locide',25,373);
insert into producto values ('Cafe negro Marca Locide',50,184);
insert into producto values ('Paquete de toallas Marca Locide',49,247);
insert into producto values ('Omeprazol Marca Locide',23,285);
insert into producto values ('cpu todo equipado Marca Locide',39,139);
insert into producto values ('llave de mano Marca Locide',26,103);
insert into producto values ('llave de pie Marca Locide',45,181);
insert into producto values ('llave de paso Marca Locide',26,408);
insert into producto values ('manguera 1 metro Marca Locide',10,381);
insert into producto values ('azucar 1 kg Marca Locide',31,41);
insert into producto values ('sal  1 kg Marca Locide',48,256);
insert into producto values ('cuadro ultima cena Marca Locide',46,431);
insert into producto values ('una hermana  Marca Locide',48,188);
insert into producto values ('muñeca system Marca Locide',41,7);
insert into producto values ('pay de queso Marca Locide',34,440);
insert into producto values ('papaya del dia Marca Locide',51,100);
insert into producto values ('Muñeca System 2.0 Marca Locide',14,156);
insert into producto values ('Auto Chevy  Marca Locide',41,257);
insert into producto values ('Pan Blanco Marca Locide',30,437);
insert into producto values ('jamon de perro 1 kg Marca Locide',33,323);
insert into producto values ('vidrio 1mx1m Marca Locide',54,56);
insert into producto values ('shampoo de perro Marca Locide',48,66);
insert into producto values ('shampo de gato Marca Locide',12,136);
insert into producto values ('shampo de humano Marca Locide',11,297);
insert into producto values ('llavero StarWars Marca Locide',24,17);

insert into producto values ('balon futbol', 45, 720);
insert into producto values ('balon basquetbol', 80, 485);
insert into producto values ('pelota tenis', 65, 480);
insert into producto values ('pelota baseball', 40, 750);
insert into producto values ('pelota voleyball', 55, 820);
insert into producto values ('playera deportiva', 80, 840);
insert into producto values ('pantalones deportivos', 65, 920);
insert into producto values ('tachos', 250, 1520);
insert into producto values ('tenis', 75, 480);
insert into producto values ('flotadores', 40, 820);
insert into producto values ('balon futbol_x', 45, 720);
insert into producto values ('balon basquetbol_x', 80, 485);
insert into producto values ('pelota tenis_x', 65, 480);
insert into producto values ('pelota baseball_x', 40, 750);
insert into producto values ('pelota voleyball_x', 55, 820);
insert into producto values ('playera deportiva_x', 80, 840);
insert into producto values ('pantalones deportivos_x', 65, 920);
insert into producto values ('tachos_x', 250, 1520);
insert into producto values ('tenis_x', 75, 480);
insert into producto values ('flotadores_x', 40, 820);
insert into producto values ('balon futbol_xy', 45, 520);
insert into producto values ('balon basquetbol_xy', 80, 685);
insert into producto values ('pelota tenis_xy', 65, 980);
insert into producto values ('pelota baseball_xy', 40, 1050);
insert into producto values ('pelota voleyball_xy', 55, 920);
insert into producto values ('playera deportiva_xy', 80, 440);
insert into producto values ('pantalones deportivos_xy', 65, 220);
insert into producto values ('tachos_xy', 250, 120);
insert into producto values ('tenis_xy', 75, 48);
insert into producto values ('flotadores_xy', 40, 80);
insert into producto values ('balon futbol_z', 45, 720);
insert into producto values ('balon basquetbol_z', 80, 485);
insert into producto values ('pelota tenis_z', 65, 480);
insert into producto values ('pelota baseball_z', 40, 750);
insert into producto values ('pelota voleyball_z', 55, 820);
insert into producto values ('playera deportiva_z', 80, 840);
insert into producto values ('pantalones deportivos_z', 65, 920);
insert into producto values ('tachos_z', 250, 1520);
insert into producto values ('tenis_z', 75, 480);
insert into producto values ('flotadores_de_messi_ :v', 40, 820);



insert into producto values ('agrifen', 50, 660);
insert into producto values ('alcohol gel', 60,820);
insert into producto values ('alegoria', 46, 75);
insert into producto values ('almura', 80, 453);
insert into producto values ('alnex', 95, 450);
insert into producto values ('amfotericina', 150, 450);
insert into producto values ('amk', 48, 303);
insert into producto values ('amofilin', 30, 652);
insert into producto values ('amoxicalv', 65, 845);
insert into producto values ('anaseptil', 49, 756);
insert into producto values ('clonixinato', 15, 654);
insert into producto values ('ciprobac', 40, 482);
insert into producto values ('combestrepal', 45, 254);
insert into producto values ('custodiol', 30, 548);
insert into producto values ('crivosin', 43, 546);
insert into producto values ('dardaren', 43, 352);
insert into producto values ('decorex', 45, 125);
insert into producto values ('duplicap', 35, 325);
insert into producto values ('drosodin', 25, 213);
insert into producto values ('durapore', 21, 215);
insert into producto values ('fotexina', 50, 660);
insert into producto values ('framebin', 60,820);
insert into producto values ('frisolac', 46, 75);
insert into producto values ('fucerox', 80, 453);
insert into producto values ('galactus', 95, 450);
insert into producto values ('gelafundin', 150, 450);
insert into producto values ('giratek', 48, 303);
insert into producto values ('grirron', 30, 652);
insert into producto values ('glupropan', 65, 845);
insert into producto values ('glutapak', 49, 756);
insert into producto values ('meprizina', 15, 654);
insert into producto values ('metamizol', 40, 482);
insert into producto values ('micro pore', 45, 254);
insert into producto values ('micro piel', 30, 548);
insert into producto values ('montipedia', 43, 546);
insert into producto values ('montruxia', 43, 352);
insert into producto values ('neomixen', 45, 125);
insert into producto values ('naxifelar', 35, 325);
insert into producto values ('neuraxa', 25, 213);
insert into producto values ('nimepis', 21, 215);

---------------------------------------------------------------Insert para Proveedor (20 registros)-------------------------------------------------------------

insert into proveedor values ('Gamesa','Av. 5 de Febrero','Zaragoza','Vega', 102 , 'Querétaro' ,74587 );
insert into proveedor values ('Araceli','Antonio Rivera','De la torre','Reforma Agraria',456,'Sinaloa',76086);
insert into proveedor values ('Pilgrims','Geo plazas','Ocote','Geo plazas',13,'Durango',96123);
insert into proveedor values ('Nestle','Primavera','Rosales','Pedregal',1460,'Querétaro',86090);
insert into proveedor values ('Mars','PuerteZuleas','Jade','Rinconada',876,'Guadalajara',94205);
insert into proveedor values ('Pepsi','Del desden','esq.Montes','la Loma',761,'Tijuana',76148);
insert into proveedor values ('Coca-Cola','EL portal','Puerta azul','Portales',112,'Leon',45867);
insert into proveedor values ('Danone','victoria','Juarez','Linda vista',01,'Monterrey',76219);
insert into proveedor values ('Bonafont','Miami','Rio','Las vegas',1141,'Zapopan',77532);
insert into proveedor values ('Oreo','Hidalgo','De los olvera','San jose',10,'Monterrey',15647);
insert into proveedor values ('Lays','Reforma','Pirul','El pueblito',30,'Tampico',76900);
insert into proveedor values ('Special K','FraybuenAventura','Las flores','Noche buena',12,'Cd.México',45180);
insert into proveedor values ('Pringles','Siempre viva','hell','El Marquez',34,'Guanajuato',56001);
insert into proveedor values ('Bimbo','Oceano','P.sherman','Wallaby',42,'Sydney',20003);
insert into proveedor values ('Kelloggs','Pedro Urtiaga','Zapata','Los robles',81,'Puebla',45689);
insert into proveedor values ('Minute Maid','San juan','Los puentes','risario',45,'chihuahua',42316);
insert into proveedor values ('FUD','Los rosales','Salinas','Los cues',741,'Merida',74691);
insert into proveedor values ('Yoplait','Ferlum','Rio verde','Menchaca',852,'Aguascalientes',75315);
insert into proveedor values ('Guten','Las frias','Morelia','Amperite',745,'Hermosillo',75984);
insert into proveedor values ('Dove','La Agraria','Casa Blanca','Salindro',45,'Saltillo',78562);

insert into proveedor values ('Microsoft','Av. De La Luz','Mayas','Cerrito Colorado', 150 , 'Querétaro' ,76116 );
insert into proveedor values ('Sony','Palmas','De la torre','Reforma Agraria',460,'Sinaloa',76086);
insert into proveedor values ('Nintendo','Geo plazas','Ocote','Geo plazas',20,'Durango',96123);
insert into proveedor values ('Fox','Primavera','Rosales','Pedregal',1502,'Querétaro',86090);
insert into proveedor values ('Motorola','PuerteZuleas','Jade','Rinconada',880,'Guadalajara',94205);
insert into proveedor values ('Huawei','Del desden','esq.Montes','la Loma',764,'Tijuana',76148);
insert into proveedor values ('Apple','EL portal','Puerta azul','Portales',118,'Leon',45867);
insert into proveedor values ('Samsung','victoria','Juarez','Linda vista',05,'Monterrey',76219);
insert into proveedor values ('Ciel','Miami','Rio','Las vegas',1155,'Zapopan',77532);
insert into proveedor values ('JBL','Hidalgo','De los olvera','San jose',09,'Monterrey',15647);
insert into proveedor values ('Nike','Reforma','Pirul','El pueblito',32,'Tampico',76900);
insert into proveedor values ('Converse','FraybuenAventura','Las flores','Noche buena',15,'Cd.México',45180);
insert into proveedor values ('Lenovo','Siempre viva','hell','El Marquez',35,'Guanajuato',56001);
insert into proveedor values ('Dell','Oceano','P.sherman','Wallaby',54,'Sydney',20003);
insert into proveedor values ('ASUS','Pedro Urtiaga','Zapata','Los robles',88,'Puebla',45689);
insert into proveedor values ('Lala','San juan','Los puentes','risario',48,'chihuahua',42316);
insert into proveedor values ('Compac','Los rosales','Salinas','Los cues',752,'Merida',74691);
insert into proveedor values ('Acer','Ferlum','Rio verde','Menchaca',860,'Aguascalientes',75315);
insert into proveedor values ('A su piso','Las frias','Morelia','Amperite',746,'Hermosillo',75984);
insert into proveedor values ('Office Depot','La Agraria','Casa Blanca','Salindro',50,'Saltillo',78562);

-- insert para Vendedor (10 registros)

select * from vendedor;
insert into vendedor values ('Diego Alejandro','1994-08-07' ,'1994-08-07' , 'Universidad');
insert into vendedor values ('Luis Sanchez','1994-07-07' ,'1999-11-05', 'Universidad');
insert into vendedor values ('David Isaias','1994-06-07' ,'1994-12-11' , 'Universidad');
insert into vendedor values ('Luis Zavala','1994-05-07' ,'1994-08-07' , 'Preparatoria');
insert into vendedor values ('Kevin el ansioso','1994-01-07' ,'1994-05-07' , 'Primaria');
insert into vendedor values ('Arturo','1994-02-07' ,'1994-04-07' , 'Preparatoria');
insert into vendedor values ('Liliana','1994-05-07' ,'1994-02-07' , 'Secundaria');
insert into vendedor values ('Pedro','1994-07-07' ,'1994-01-07' , 'Universidad');
insert into vendedor values ('Kenia','1994-02-07' ,'1994-04-07' , 'Primaria');
insert into vendedor values ('Daniel','1994-01-07' ,'1994-06-07' , 'Preparatoria');
insert into vendedor values ('Diego','1994-08-07' ,'1994-08-07' , 'Universidad');
insert into vendedor values ('Luis','1994-07-07' ,'1999-11-05', 'Universidad');
insert into vendedor values ('David','1994-06-07' ,'1994-12-11' , 'Universidad');
insert into vendedor values ('Luis','1994-05-07' ,'1994-08-07' , 'Preparatoria');
insert into vendedor values ('Kevin','1994-01-07' ,'1994-05-07' , 'Primaria');
insert into vendedor values ('Arturo','1994-02-07' ,'1994-04-07' , 'Preparatoria');
insert into vendedor values ('Liliana','1994-05-07' ,'1994-02-07' , 'Secundaria');
insert into vendedor values ('Pedro','1994-07-07' ,'1994-01-07' , 'Universidad');
insert into vendedor values ('Kenia','1994-02-07' ,'1994-04-07' , 'Primaria');
insert into vendedor values ('Daniel','1994-01-07' ,'1994-06-07' , 'Preparatoria');


insert into venta values ('20-10-2018', 3900, 15);
insert into venta values ('20-10-2018', 890, 10);
insert into venta values ('20-10-2018', 900, 10);
insert into venta values ('20-10-2018', 890, 5);
insert into venta values ('20-10-2018', 720, 20);
insert into venta values ('20-10-2018', 3110, 25);
insert into venta values ('20-10-2018', 999, 12);
insert into venta values ('20-10-2018', 200, 5);
insert into venta values ('20-10-2018', 330, 40);
insert into venta values ('20-10-2018', 4900, 50);	
insert into venta values ('20-10-2018', 150, 0);
insert into venta values ('20-10-2018', 290, 15);
insert into venta values ('20-10-2018', 900, 25);
insert into venta values ('20-10-2018', 1100, 50);
insert into venta values ('20-10-2018', 4900, 25);
insert into venta values ('20-10-2018', 500, 0);
insert into venta values ('20-10-2018', 2000, 15);
insert into venta values ('20-10-2018', 400, 40);
insert into venta values ('20-10-2018', 300, 5);
insert into venta values ('20-10-2018', 4910, 15);
insert into venta values ('20-10-2018', 3300, 40);
insert into venta values ('20-10-2018', 550, 15);	
insert into venta values ('20-10-2018', 300, 5);
insert into venta values ('20-10-2018', 3400, 45);
insert into venta values ('20-10-2018', 10900, 70);
insert into venta values ('20-10-2018', 1330, 15);
insert into venta values ('20-10-2018', 1300, 20);
insert into venta values ('20-10-2018', 11300, 60);
insert into venta values ('20-10-2018', 1900, 5);
insert into venta values ('20-10-2018', 14500, 45);
insert into venta values ('20-10-2018', 1300, 50);
insert into venta values ('20-10-2018', 300, 10);
insert into venta values ('20-10-2018', 1890, 15);
insert into venta values ('20-10-2018', 1900, 25);
insert into venta values ('20-10-2018', 14000, 15);
insert into venta values ('20-10-2018', 13300, 20);
insert into venta values ('20-10-2018', 20000, 70);
insert into venta values ('20-10-2018', 2300, 5);
insert into venta values ('20-10-2018', 3200, 15);
insert into venta values ('20-10-2018', 3100, 20);
insert into venta values ('20-10-2018', 3010, 15);
insert into venta values ('20-10-2018', 12300, 25);
insert into venta values ('20-10-2018', 100, 5);
insert into venta values ('20-10-2018', 5300, 25);
insert into venta values ('20-10-2018', 15300, 40);
insert into venta values ('20-10-2018', 12500, 55);
insert into venta values ('20-10-2018', 4300, 55);
insert into venta values ('20-10-2018', 2300, 30);
insert into venta values ('20-10-2018', 120, 0);
insert into venta values ('20-10-2018', 3700, 15);
insert into venta values ('20-10-2018', 2020, 35);
insert into venta values ('20-10-2018', 1200, 30);
insert into venta values ('20-10-2018', 4000, 15);
insert into venta values ('20-10-2018', 15300, 20);
insert into venta values ('20-10-2018', 1200, 50);
insert into venta values ('20-10-2018', 23300, 75);
insert into venta values ('20-10-2018', 2300, 50);
insert into venta values ('20-10-2018', 15000, 60);
insert into venta values ('15-11-2018', 50000, 99);
insert into venta values ('15-11-2018', 3900, 15);
insert into venta values ('15-11-2018', 1534, 20);
insert into venta values ('15-11-2018', 2354, 17);
insert into venta values ('15-11-2018', 1561, 26);
insert into venta values ('15-11-2018', 2157, 14);
insert into venta values ('15-11-2018', 156, 19);
insert into venta values ('15-11-2018', 147, 20);
insert into venta values ('15-11-2018', 1864, 47);
insert into venta values ('15-11-2018', 1746, 43);
insert into venta values ('15-11-2018', 1387, 20);
insert into venta values ('15-11-2018', 3547, 19);
insert into venta values ('15-11-2018', 3489, 34);
insert into venta values ('15-11-2018', 1467, 41);
insert into venta values ('15-11-2018', 1643, 34);
insert into venta values ('15-11-2018', 2496, 10);
insert into venta values ('15-11-2018', 2134, 9);
insert into venta values ('15-11-2018', 1765, 8);
insert into venta values ('15-11-2018', 1876, 14);
insert into venta values ('15-11-2018', 6479, 16);
insert into venta values ('15-11-2018', 4671, 20);
insert into venta values ('15-11-2018', 5100, 34);
insert into venta values ('15-11-2018', 1684, 37);
insert into venta values ('15-11-2018', 1475, 62);
insert into venta values ('15-11-2018', 4568, 47);
insert into venta values ('15-11-2018', 4790, 20);
insert into venta values ('15-11-2018', 2456, 30);
insert into venta values ('15-11-2018', 1384, 29);
insert into venta values ('15-11-2018', 1547, 37);
insert into venta values ('15-11-2018', 3648, 38);
insert into venta values ('15-11-2018', 1798, 29);
insert into venta values ('15-11-2018', 4568, 19);
insert into venta values ('15-11-2018', 2486, 10);
insert into venta values ('15-11-2018', 1264, 25);
insert into venta values ('15-11-2018', 4975, 16);
insert into venta values ('15-11-2018', 6482, 10);
insert into venta values ('15-11-2018', 3548, 17);
insert into venta values ('15-11-2018', 1654, 18);
insert into venta values ('15-11-2018', 1354, 19);
insert into venta values ('15-11-2018', 1547, 20);
insert into venta values ('15-11-2018', 351, 20);
insert into venta values ('15-11-2018', 486, 15);
insert into venta values ('15-11-2018', 235, 10);
insert into venta values ('15-11-2018', 756, 15);
insert into venta values ('15-11-2018', 461, 15);
insert into venta values ('15-11-2018', 254, 12);
insert into venta values ('15-11-2018', 1235, 12);
insert into venta values ('15-11-2018', 2468, 10);
insert into venta values ('15-11-2018', 7654, 45);
insert into venta values ('15-11-2018', 6482, 46);
insert into venta values ('15-11-2018', 4862, 32);
insert into venta values ('15-11-2018', 8641, 17);
select * from cliente;

insert into cliente values ('Luis Alfonso Sanchez Flores', 'Flores Malagon', 'Malagon', 'San Francisco', 420, 'Queretaro', 76000);
insert into cliente values ('David Isaias Rosales Castillo', 'La recondita', 'San Jose', 'De las casas', 30, 'Queretaro', 76100);
insert into cliente values ('Jesus Ulises Alonso Rivera', 'Rinconada de las Fuentes', 'Recondito', 'Florales', 330, 'Queretaro', 76200);
insert into cliente values ('Patricia Zuñiga Ortega', 'Mirabel Occidental', 'Vista Azul', 'San Diego', 3300, 'Queretaro', 76303);
insert into cliente values ('Alejandro Flores Hernandez', 'El Peje', 'Presidentes', 'Miramontes', 110, 'Queretaro', 76021);
insert into cliente values ('Diego Armando Maradona', 'Deportes Oeste', 'Milagros', 'La mano de Dios', 360, 'Queretaro', 76010);
insert into cliente values ('Jorge Andrade Mandujano', 'El Marques', 'Doctores', 'Medicos', 821, 'Queretaro', 76045);
insert into cliente values ('Daniela Amairani Gomez Gachuzo', 'Flores', 'Athenas', 'Azteca', 111, 'Queretaro', 76030);
insert into cliente values ('Carlos Alfredo Jimenez Castillo', 'Miralejos', 'Escuderos', 'Paraiso', 663, 'Queretaro', 76020);
insert into cliente values ('Axel Rafael Ramirez Acevedo', 'Inferno', 'Occidente', 'Palmas', 696, 'Queretaro', 76023);
insert into cliente values ('Claudia Fernanda Ordaz de la Mora', 'Vista Alegre', 'Santo Tom�s', 'Av. Grecia', 2203, 'Queretaro', 76102);
insert into cliente values ('Christian Emmanuel Martinez Arroyo', 'Pie de la Cuesta', 'Privada de las Fuentes', 'Miracasas', 1220, 'Queretaro', 76206);
insert into cliente values ('Diego Alejandro Delgadillo Gomez', 'Cascadas', 'Agua Dulce', 'Reversiva', 923, 'Queretaro', 76900);
insert into cliente values ('Marilyin Manson', 'Infierno', 'Belcebu', 'Agua Salada', 666, 'Queretaro', 76666);
insert into cliente values ('Jesus Roberto Alcantar Palacios', 'Liga Noreste', 'Leyendas', 'Diamante', 420, 'Queretaro', 76019);
insert into cliente values ('Jose Andres Velazquez Briones', 'Ventanas Relucientes', 'Paraiso', 'San Fernando', 4330, 'Queretaro', 76151);
insert into cliente values ('Diego Gonzalez Andrade', 'Malaventura', 'Relicario', 'De Hierro', 3100, 'Queretaro', 76201);
insert into cliente values ('Cynthia Adriana Rodriguez Martinez', 'Tecnologos', 'De la Gloria', 'Y la luz', 3030, 'Queretaro', 76201);
insert into cliente values ('Maria Jose Saavedra Ruiz', 'Cristales Marrones', 'Arroyo Negro', 'Guadalajara', 0001, 'Queretaro', 76017);
insert into cliente values ('Diney Perez Garcia', 'Corazones Rotos', 'Sentimientos', 'Agua Azul', 609, 'Queretaro', 76208);
insert into cliente values ('Jessica Daniela Aguilar Rodriguez', 'Avenida del Paraiso', 'Cascadas Rojas', 'Unico Santuario', 520, 'Queretaro', 76009);
insert into cliente values ('Esteban Cielo Hernandez', 'Av. Innovacion', 'Informativos', 'Periodistas', 110, 'Queretaro', 76333);
insert into cliente values ('Victor Gabriel Mostalac Jimenez', 'Platino Ardiente', 'Cascada Seca', 'Santo Luis', 3200, 'Queretaro', 76070);
insert into cliente values ('Emmanuel Alejandro Nava Arevalo', 'Av. Victoria', 'Hidro Innovacion', 'Negreta', 420, 'Queretaro', 76200);
insert into cliente values ('Ricardo Castro Hernandez', 'Arnulfo', 'Miramontes', 'Oasis', 430, 'Queretaro', 76280);
insert into cliente values ('Luis Alfonso Molina Rivera', 'Maya', 'Azteca', 'Tolteca', 1100, 'Queretaro', 76420);
insert into cliente values ('Rosa Rivera Rodriguez', 'Cultural', 'Centro', 'Solo Dios', 4300, 'Queretaro', 76290);
insert into cliente values ('Luis Fernando Zavala Gonzalez', 'Ricardo Castro', 'Fraccionamiento Panoramico', 'Arnulfo Miramontes', 420, 'Queretaro', 76000);
insert into cliente values ('Jose Arturo Sanchez Castro', 'Fidel', 'Av. Revolucion', 'Cuba', 3023, 'Queretaro', 76089);
insert into cliente values ('Mauricio Vilchiz Cortez', 'Candidatos', 'Corrupcion', 'Circuito Periferico', 3302, 'Queretaro', 76030);
insert into cliente values ('Joaquin Guzman Loera', 'Protectivos', 'Malavida', 'Exclusion', 4050, 'Queretaro', 76022);
insert into cliente values ('Antonio Sanchez Islas', 'Neo Geo', 'Recreativos', 'Onda Vital', 30312, 'Queretaro', 76019);
insert into cliente values ('Gustavo Ortega Becerra', 'Rayando Casas', 'Pipomuere', 'Vintage', 959, 'Queretaro', 76021);
insert into cliente values ('Alejandro Fernandez Martinez', 'Cedillo', 'Visca Catalunya', 'Contigopipo', 107, 'Queretaro', 76310);
insert into cliente values ('Kevin Saenz Hernandez', 'El Rosario', 'El Carmen', 'Solaris', 3012, 'Queretaro', 76090);
insert into cliente values ('Diego Sainz Rodriguez', 'A todo Gas', 'Valeriana', 'Centeno', 221, 'Queretaro', 76212);
insert into cliente values ('Jose Luis Lara Hernandez', 'Millares', 'Centenar', 'Unidad', 115, 'Queretaro', 76159);
insert into cliente values ('Mauricio Hernandez Hernandez', 'Bandolero', 'Calletana', 'Reformacion', 801, 'Queretaro', 76094);
insert into cliente values ('Omar Hernandez Betancourt', 'Venecia', 'Artyomich', 'Metro', 2033, 'Queretaro', 76095);
insert into cliente values ('Francia Salas Hernandez', 'Año Nuevo', 'Festividades', 'Obsidiana', 3010, 'Queretaro', 76231);

insert into clientes values ('Craig Feldspard','Lois Loves 69','In the middle','Malcolm','4422222220','Manhatan',98096);
insert into clientes values ('Aquiles Brinco','Albures 343','Heilo','Graficos 1','4422222221','Belcebu','98097');
insert into clientes values ('Aquiles Baesa','Imaginacion 0','Inquisidores','Outta Space','4422222223','Anillos',98098);
insert into clientes values ('Arnold Mandela','Hoy te vas','La carencia','Bullshit','4422222224','Everybody',98099);
insert into clientes values ('Miranda Keyes','Pero se que volveras','Lol','Backstreet','4422222225','Rock Your Body',98100);
insert into clientes values ('John Siera','Porque lo que yo te di','Boys','Yeah','4422222226','Yeeeah',98101);
insert into clientes values ('Johnson Malone','No lo encontraras jamas','Acara','Dont know','4422222227','Everybody',98102);
insert into clientes values ('Cortana IA','Esas noches','Just shut up','Meassure','4422222228','Rock Your Body',98103);
insert into clientes values ('Carl Johnson','Esos dias','Never Give UP','Its john cena','4422222229','Backstreets back',98104);
insert into clientes values ('Corey Taylor','Cuando tu te','Tuturutuu','And his name is','4423222220','Alright',98105);
insert into clientes values ('Dolores Oriordan','Retorcias en','Faker what','Was that','4423222221','League',98106);
insert into clientes values ('Jimmy Hendrix','Mis brazos','Look at the moves','ExPeke','4423222222','Backdoor',98107);
insert into clientes values ('Slash','In your head','And their bones','In your head','4423222223','Zombie',98108);
insert into clientes values ('Curt Cobain','Feels Like','Teen Spirit','Nutella','4423222224','Mosquito',98109);
insert into clientes values ('Neil Armstrong','Lithium','Unique and','Different','4423222225','A mulatto',98110);
insert into clientes values ('M. Shadows','A7X','Bat Country','Idontknow','4423222226','Beautiful',98111);
insert into clientes values ('Synester Gates','Avenged','Sevenfold','Welcome to','4423222227','The Family',98112);
insert into clientes values ('Zacky Vengance','Avenged X7','Sevenx7','Hail to','4423222228','The king',98113);
insert into clientes values ('Johnny Christ','Dear','God','Nightmare','4423222229','Its a nightmare',98114);
insert into clientes values ('Brooks Wackerman','So Far','Away','Never','4424222222','This means',98115);
insert into clientes values ('The Rev','The Stage','This means war','Gunslinger','4424222221','Breath',98116);
insert into clientes values ('Mike Portnoy','Critical Acclaim','Almost Easy','Carry On','4424222222','Spit',98117);
insert into clientes values ('Arin Ilejay','Danger Line','Not ready','To Die','4424222223','Walk',98118);
insert into clientes values ('Matt Wendt','Blinded In','Chains','Bromptom','4424222225','Chapter Four',98119);
insert into clientes values ('Justin Meacham','Burn it down','Second Heartbeat','Cocktail','4424222226','Nose',98120);
insert into clientes values ('Daemon Ash','Afterlife','Dear God','Buried Alive','4424222227','Equisde',98121);
insert into clientes values ('Joey Jordison','Duality','Snuff','Wait and Bleed','4424222228','Exdi',98122);
insert into clientes values ('Paul Gray','The Devil in I','Psychosocial','Spit it out','4424222229','Thememes',98123);
insert into clientes values ('Jim Root','Killpop','Dead Memories','Eyeless','4425222220','Do you know',98124);
insert into clientes values ('Shawn Crahan','Left Behind','XIX','Vermillion 2','4425222221','Tha wae',98125);
insert into clientes values ('Mick Thomson','People Equals sht','Lolazo','The Heretic','4425222222','Ma brotha',98126);
insert into clientes values ('Sid Wilson','Vermillion','Disasterpiece','The negative One','4425222223','Mims',98127);
insert into clientes values ('Chris Fehn','Pulse of the','Maggots','Surfacing','4425222224','Wakanda',98128);
insert into clientes values ('Craig Jones','Sarcastrophe','Custer','My Plague','4425222225','Uacanda',98129);
insert into clientes values ('Jay Weinberg','The Nameless','Sulfur','Everything Ends','4425222226','Guacanda',98130);
insert into clientes values ('Anders Colsefni','The Blister Exists','All Hope','Is gone','4425222227','Wacanda',98131);
insert into clientes values ('Alessandro Venturela','AOV','Three Nill','I am Hated','4425222228','Guakanda',98132);
insert into clientes values ('Matt Tuck','Tears dont','Fall','Your Betrayal','4425222229','Uakanda',98133);
insert into clientes values ('Michael Padget','Waking the Demon','4 Words','Scream Aim','4426222220','Tha Wae',98133);
insert into clientes values ('Jason James','No Way Out','Rasing Hell','You want a battle','4426222221','Da Wae',98134);
/*********************************************fin insert tablas fuertes***************************************************/

/*------------------------------------------inicio insert tablas debiles--------------------------------------------------*/
/*
    _____   _______ __________  ___________    _______   __   _________    ____  __    ___   _____    ____  __________  ______    ___________
   /  _/ | / / ___// ____/ __ \/_  __/ ___/   / ____/ | / /  /_  __/   |  / __ )/ /   /   | / ___/   / __ \/ ____/ __ )/  _/ /   / ____/ ___/
   / //  |/ /\__ \/ __/ / /_/ / / /  \__ \   / __/ /  |/ /    / / / /| | / __  / /   / /| | \__ \   / / / / __/ / __  |/ // /   / __/  \__ \ 
 _/ // /|  /___/ / /___/ _, _/ / /  ___/ /  / /___/ /|  /    / / / ___ |/ /_/ / /___/ ___ |___/ /  / /_/ / /___/ /_/ // // /___/ /___ ___/ / 
/___/_/ |_//____/_____/_/ |_| /_/  /____/  /_____/_/ |_/    /_/ /_/  |_/_____/_____/_/  |_/____/  /_____/_____/_____/___/_____/_____//____/  
                                                                                                                                             
*/

insert into provee(id_proveedor, id_producto, fecha, cantidad) values(1,1,'14-02-2018',300);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(2,2,'14-02-2018',145);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(3,3,'14-02-2018',234);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(4,4,'14-02-2018',10);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(5,5,'14-02-2018',3220);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(6,6,'14-02-2018',13765);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(7,7,'14-02-2018',12980);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(8,8,'14-02-2018',123);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(9,9,'14-02-2018',1234567);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(10,10,'14-02-2018',998756);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(11,11,'14-02-2018',300);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(12,12,'14-02-2018',145);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(13,13,'14-02-2018',234);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(14,14,'14-02-2018',10);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(15,15,'14-02-2018',3220);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(16,16,'14-02-2018',13765);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(17,17,'14-02-2018',12980);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(18,18,'14-02-2018',123);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(19,19,'14-02-2018',1234567);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(20,20,'14-02-2018',998756);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(19,1,'06-04-2018',223);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(4,12,'14-03-2018',132);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(9,1,'06-04-2018',234);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(4,14,'12-03-2018',330);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(19,1,'06-04-2018',323);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(20,16,'14-03-2018',143);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(19,1,'06-04-2018',121);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(18,18,'14-03-2018',154);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(19,1,'06-04-2018',127);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(20,20,'12-03-2018',222);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(1,1,'12-03-2018',377);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(1,2,'14-02-2018',14523);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(1,3,'12-03-2018',2753);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(1,4,'14-02-2018',1433);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(1,5,'12-03-2018',365);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(2,6,'14-02-2018',1234);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(2,7,'12-03-2018',17465);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(8,8,'14-02-2019',6506
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(3,9,'14-02-2018',12547);
insert into provee(id_proveedor, id_producto, fecha, cantidad) values(10,10,'14-02-2018',996);


insert into detalle(id_producto, id_venta, cantidad, fecha) values(1,1,300,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(2,2,145,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(3,3,234,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(4,4,10,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(5,5,3220,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(6,6,13765,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(7,7,12980,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(8,8,123,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(9,9,1234567,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(10,10,998756,'19-09-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(11,11,300,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(12,12,145,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(13,13,234,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(14,14,10,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(15,15,3220,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(16,16,13765,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(17,17,12980,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(18,18,123,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(19,19,1234567,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(20,20,998756,'19-09-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(21,20,998756,'19-09-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(21,20,998756,'19-09-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(21,20,998756,'19-09-2018'); 
insert into detalle(id_producto, id_venta, cantidad, fecha) values(23,23,300,'06-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(24,24,145,'01-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(25,25,234,'02-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(26,26,210,'02-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(27,27,220,'02-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(28,28,1765,'04-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(29,29,1380,'04-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(30,30,133,'04-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(31,31,12327,'04-04-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(32,32,9756,'07-04-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(33,33,300,'19-02-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(34,34,145,'19-02-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(35,35,234,'19-02-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(36,36,10,'19-02-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(37,37,320,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(38,38,13765,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(39,39,2380,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(40,40,123,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(41,41,1367,'19-09-2018');
insert into detalle(id_producto, id_venta, cantidad, fecha) values(42,42,2356,'11-02-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(43,43,48756,'11-02-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(44,44,9456,'11-02-2018');  
insert into detalle(id_producto, id_venta, cantidad, fecha) values(45,45,4343,'11-02-2018'); 


select * from detalle; 

insert into realiza (id_venta,id_vendedor) values(1,1);
insert into realiza (id_venta,id_vendedor) values(2,2);
insert into realiza (id_venta,id_vendedor) values(3,3);
insert into realiza (id_venta,id_vendedor) values(4,4);
insert into realiza (id_venta,id_vendedor) values(5,5);
insert into realiza (id_venta,id_vendedor) values(6,6);
insert into realiza (id_venta,id_vendedor) values(7,7);
insert into realiza (id_venta,id_vendedor) values(8,8);
insert into realiza (id_venta,id_vendedor) values(9,9);
insert into realiza (id_venta,id_vendedor) values(10,10);
insert into realiza (id_venta,id_vendedor) values(11,11);
insert into realiza (id_venta,id_vendedor) values(12,12);
insert into realiza (id_venta,id_vendedor) values(13,13);
insert into realiza (id_venta,id_vendedor) values(14,14);
insert into realiza (id_venta,id_vendedor) values(15,15);
insert into realiza (id_venta,id_vendedor) values(16,16);
insert into realiza (id_venta,id_vendedor) values(17,17);
insert into realiza (id_venta,id_vendedor) values(18,18);
insert into realiza (id_venta,id_vendedor) values(19,19);
insert into realiza (id_venta,id_vendedor) values(20,20);
insert into realiza (id_venta,id_vendedor) values(21,21);
insert into realiza (id_venta,id_vendedor) values(22,22);
insert into realiza (id_venta,id_vendedor) values(23,23);
insert into realiza (id_venta,id_vendedor) values(24,24);
insert into realiza (id_venta,id_vendedor) values(25,25);
insert into realiza (id_venta,id_vendedor) values(26,26);
insert into realiza (id_venta,id_vendedor) values(27,27);
insert into realiza (id_venta,id_vendedor) values(28,28);
insert into realiza (id_venta,id_vendedor) values(29,29);
insert into realiza (id_venta,id_vendedor) values(30,30);
insert into realiza (id_venta,id_vendedor) values(31,31);
insert into realiza (id_venta,id_vendedor) values(32,32);
insert into realiza (id_venta,id_vendedor) values(33,33);
insert into realiza (id_venta,id_vendedor) values(34,34);
insert into realiza (id_venta,id_vendedor) values(35,35);
insert into realiza (id_venta,id_vendedor) values(36,36);
insert into realiza (id_venta,id_vendedor) values(37,37);
insert into realiza (id_venta,id_vendedor) values(38,38);
insert into realiza (id_venta,id_vendedor) values(39,39);
insert into realiza (id_venta,id_vendedor) values(40,40);


insert into compra (id_venta, id_cliente) values(1,1);
insert into compra (id_venta, id_cliente) values(2,2);
insert into compra (id_venta, id_cliente) values(3,3);
insert into compra (id_venta, id_cliente) values(4,4);
insert into compra (id_venta, id_cliente) values(5,5);
insert into compra (id_venta, id_cliente) values(6,6);
insert into compra (id_venta, id_cliente) values(7,7);
insert into compra (id_venta, id_cliente) values(8,8);
insert into compra (id_venta, id_cliente) values(9,9);
insert into compra (id_venta, id_cliente) values(10,10);
insert into compra (id_venta, id_cliente) values(11,11);
insert into compra (id_venta, id_cliente) values(12,12);
insert into compra (id_venta, id_cliente) values(13,13);
insert into compra (id_venta, id_cliente) values(14,14);
insert into compra (id_venta, id_cliente) values(15,15);
insert into compra (id_venta, id_cliente) values(16,16);
insert into compra (id_venta, id_cliente) values(17,17);
insert into compra (id_venta, id_cliente) values(18,18);
insert into compra (id_venta, id_cliente) values(19,19);
insert into compra (id_venta, id_cliente) values(20,20);
insert into compra (id_venta, id_cliente) values(21,21);
insert into compra (id_venta, id_cliente) values(22,22);
insert into compra (id_venta, id_cliente) values(23,23);
insert into compra (id_venta, id_cliente) values(24,24);
insert into compra (id_venta, id_cliente) values(25,25);
insert into compra (id_venta, id_cliente) values(26,26);
insert into compra (id_venta, id_cliente) values(27,27);
insert into compra (id_venta, id_cliente) values(28,28);
insert into compra (id_venta, id_cliente) values(29,29);
insert into compra (id_venta, id_cliente) values(30,30);
insert into compra (id_venta, id_cliente) values(31,31);
insert into compra (id_venta, id_cliente) values(32,32);
insert into compra (id_venta, id_cliente) values(33,33);
insert into compra (id_venta, id_cliente) values(34,34);
insert into compra (id_venta, id_cliente) values(35,35);
insert into compra (id_venta, id_cliente) values(36,36);
insert into compra (id_venta, id_cliente) values(37,37);
insert into compra (id_venta, id_cliente) values(38,38);
insert into compra (id_venta, id_cliente) values(39,39);
insert into compra (id_venta, id_cliente) values(40,40);

select * from producto;
select * from categoria;

insert into clasifica(id_categoria, id_producto) values(1,1);
insert into clasifica(id_categoria, id_producto) values(2,2);
insert into clasifica(id_categoria, id_producto) values(3,3);
insert into clasifica(id_categoria, id_producto) values(4,4);
insert into clasifica(id_categoria, id_producto) values(5,5);
insert into clasifica(id_categoria, id_producto) values(6,6);
insert into clasifica(id_categoria, id_producto) values(7,7);
insert into clasifica(id_categoria, id_producto) values(8,8);
insert into clasifica(id_categoria, id_producto) values(9,9);
insert into clasifica(id_categoria, id_producto) values(10,10);
insert into clasifica(id_categoria, id_producto) values(11,11);
insert into clasifica(id_categoria, id_producto) values(12,12);
insert into clasifica(id_categoria, id_producto) values(13,13);
insert into clasifica(id_categoria, id_producto) values(14,14);
insert into clasifica(id_categoria, id_producto) values(15,15);
insert into clasifica(id_categoria, id_producto) values(16,16);
insert into clasifica(id_categoria, id_producto) values(17,17);
insert into clasifica(id_categoria, id_producto) values(18,18);
insert into clasifica(id_categoria, id_producto) values(19,19);
insert into clasifica(id_categoria, id_producto) values(20,20);
insert into clasifica(id_categoria, id_producto) values(21,21);
insert into clasifica(id_categoria, id_producto) values(22,22);
insert into clasifica(id_categoria, id_producto) values(23,23);
insert into clasifica(id_categoria, id_producto) values(24,24);
insert into clasifica(id_categoria, id_producto) values(25,25);
insert into clasifica(id_categoria, id_producto) values(26,26);
insert into clasifica(id_categoria, id_producto) values(27,27);
insert into clasifica(id_categoria, id_producto) values(28,28);
insert into clasifica(id_categoria, id_producto) values(29,29);
insert into clasifica(id_categoria, id_producto) values(30,30);
insert into clasifica(id_categoria, id_producto) values(31,31);
insert into clasifica(id_categoria, id_producto) values(32,32);
insert into clasifica(id_categoria, id_producto) values(33,33);
insert into clasifica(id_categoria, id_producto) values(34,34);
insert into clasifica(id_categoria, id_producto) values(35,35);
insert into clasifica(id_categoria, id_producto) values(36,36);
insert into clasifica(id_categoria, id_producto) values(37,37);
insert into clasifica(id_categoria, id_producto) values(38,38);
insert into clasifica(id_categoria, id_producto) values(39,39);
insert into clasifica(id_categoria, id_producto) values(40,40);



/********************************************fin insert tablas debiles***************************************************************/

/*-------------------------------------------inicio de chequeo de reglas a inserts-------------------------------------------------------------*/


--Proveedor
insert into proveedor(direccion,calle,colonia,numero,ciudad,cp) values('palmas IV','vegas monrroy','los mariscos',234,'marci',37343);
insert into proveedor(nombre,direccion,colonia,numero,ciudad,cp) values('whish','wantong ming','Vega', 102 , 'China' ,74587);
insert into proveedor(nombre,direccion,calle,numero,ciudad,cp) values('AliExores','Av. 5 de Febrero','Vega', 102 , 'Puebla' ,98767 );
insert into proveedor(nombre,direccion,calle,colonia,ciudad,cp) values('Tabaco expres','Av. 5 de Febrero','Zaragoza','Vega','Nayarit' ,34592);
insert into proveedor(nombre,direccion,calle,colonia,numero,cp) values('Corona','Av. 5 de Febrero','Zaragoza','Vega', 102 ,70090 );
insert into proveedor(nombre,direccion,calle,colonia,numero,ciudad) values('Sabritas','Av. 5 de Febrero','Martinez','Vega', 102 , 'Sinaloa');

--Categoria
insert into categoria(descripcion) values ('Lo mejor del chile mexicano a su mesa');
insert into categoria(nombre) values ('Picante explosivo');


--Cliente
insert into cliente(direccion, colonia , numero, ciudad , cp ) 
values ('Flores Malagon', 'Malagon', 420, 'Queretaro', 76000);

insert into cliente (nombre ,colonia , numero, ciudad , cp ) 
values ('Mirna Flores sanz','Malagon', 986,'Queretaro', 76000);

insert into cliente (nombre , direccion, colonia , ciudad , cp ) 
values('Laura Sanchez Flores', 'Flores', 'Mareas','tijuana', 76000);

insert into cliente(nombre , direccion, colonia , numero, cp )
values ('Alfonso casillas Flores', 'Flores Malagon', 'Malagon', 420, 76000);

insert into cliente (nombre , direccion, colonia , numero, ciudad)
values ('Alfonso Gutierrez Flores', 'Flores Malagon', 'Malagon', 420, 'Queretaro');



--Venta
--fecha, total, descuento 
insert into venta (id_venta,descuento)values (150, 0);
insert into venta (fecha,descuento)values ('2018-10-04', 40);
insert into venta (fecha,total)values ('2018-10-15',678);
insert into venta (fecha,id_venta)values ('2018-10-12', 150);

--Producto
--nombre , precio not null , existencias > 0
insert into producto (precio , existencias) values (12 ,4645 );
insert into producto (nombre , existencias) values ('Sopa bilitas',4645 );
insert into producto (nombre , precio) values ('Sopa bilitas',87);
insert into producto (nombre , precio,existencias) values ('Sopa bilitas',87,-98);

--Vendedor 
--(nombre->desco, fecha_contrato->get, fecha_nacimiento not null, escolaridad ->desconocida);
insert into vendedor (fecha_contrato, fecha_nacimiento, escolaridad) values('2006-12-12' ,'1920-09-21' , 'Doctorado en IA');
insert into vendedor (nombre, fecha_nacimiento, escolaridad) values('Ramon', '1991-09-25' , 'Universidad');
insert into vendedor (nombre, fecha_contrato, escolaridad) values('Pedro','2006-03-12' , 'Universidad');
insert into vendedor (nombre, fecha_contrato, fecha_nacimiento) values('Jessica','2005-11-29' ,'1991-09-12'); 

select * from vendedor;

/*intentando violar reglas de compra*/
insert into compra (id_venta, id_cliente) values(11,null);
insert into compra (id_venta, id_cliente) values(10,10);
insert into compra (id_venta, id_cliente) values(null,1223);
insert into compra (id_compra, id_venta, id_cliente) values(1,11,232);

/*inserts que no cumplen las reglas pR clasifica*/
insert into clasifica(id_categoria, id_producto) values(null,10);
insert into clasifica(id_categoria, id_producto) values(32,6);
insert into clasifica(id_categoria, id_producto) values(4,10);


/*intentando violar las reglas de detalle*/
insert into detalle(id_producto, id_venta, cantidad) values(10,10,998756);
insert into detalle(id_producto, id_venta, cantidad) values(null,120,998756);
insert into detalle(id_detalle,id_producto, id_venta, cantidad) values(1,110,10,998756);


select * from detalle;/*las fechas coinciden con la regla de la fecha*/

/*intentando violar las reglas para realiza*/
insert into realiza (id_venta,id_vendedor) values(null,null);
insert into realiza (id_venta,id_vendedor) values(10,242);
insert into realiza (id_realiza,id_venta,id_vendedor) values(1,10,242);
/********************************************fin violacion a inserts*****************************************************************/


--Foreing keys
alter table provee add constraint FK_provee_id_producto foreign key(id_producto) references producto(id_producto) on delete cascade on update cascade;
alter table provee add constraint FK_provee_id_proveedor foreign key(id_proveedor) references proveedor(id_proveedor) on delete cascade on update cascade;

alter table clasifica add constraint FK_clasifica_idcategoria foreign key(id_categoria) references categoria(id_categoria) on delete cascade on update cascade;
alter table clasifica add constraint FK_clasifica_idproducto foreign key(id_producto) references producto(id_producto) on delete cascade on update cascade;

alter table detalle add constraint FK_detalle_idventa foreign key(id_venta) references venta(id_venta) on delete cascade on update cascade;
alter table detalle add constraint FK_detalle_idproducto foreign key(id_producto) references producto(id_producto) on delete cascade on update cascade;

alter table compra add constraint FK_compra_idventa foreign key(id_venta) references venta(id_venta) on delete cascade on update cascade;
alter table compra add constraint FK_compra_idcliente foreign key(id_cliente) references cliente(id_cliente) on delete cascade on update cascade;

alter table realiza add constraint FK_realiza_idventa foreign key(id_venta) references venta(id_venta) on delete cascade on update cascade;
alter table realiza add constraint FK_realiza_idvendedor foreign key(id_vendedor) references vendedor(id_vendedor) on delete cascade on update cascade;