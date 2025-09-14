/*
1. Cree una tabla llamada TB_OBJETOS con los siguientes atributos: NOMBRE, CODIGO, FECHA_CREACION, FECHA_MODIFICACION, TIPO, ESQUEMA_ORIGINAL
Recorra la vista ALL_OBJECTS y rellene esta tabla con los datos que se aportan en la vista. Use un cursor y no un INSERT.
*/

create table tb_objetos (
NOMBRE varchar2(50), CODIGO number , FECHA_CREACION date , FECHA_MODIFICACION date , TIPO varchar(50), ESQUEMA_ORIGINAL varchar(50));

select * from all_objects;

--Salen demasiados as� que vamos a usar �nicamente la informaci�n de los owner UBD% y DOCENCIA.

select object_name, object_id, created, last_ddl_time, object_type, owner from all_objects where owner like 'UBD%' or owner = 'DOCENCIA';

-- Se podr�a hacer usando INSERT directamente:
insert into tb_objetos 
select object_name, object_id, created, last_ddl_time, object_type, owner from all_objects where owner like 'UBD%' or owner='DOCENCIA';

--Pero, hagamoslo con cursores, as� que vaciamos la tabla:
delete tb_objetos; -- borra los datos de la tabla (y hay rollback)
truncate table tb_objetos; -- borra los datos de la tabla y no se puede hacer rollback

-- Ahora la rellenamos con cursores:

declare
    cursor crecorre is select object_name, object_id, created, last_ddl_time, object_type, owner 
                        from all_objects where owner like 'UBD%' or owner='DOCENCIA';
    begin 
        for vfila in crecorre loop 
            insert into tb_objetos values vfila;
        end loop;
    end;
/

-- Si queremos imprimir la lista de objetos (en vez de meterla en la tabla):

set serveroutput on;
declare
    cursor crecorre is select object_name, object_id, created, last_ddl_time, object_type, owner 
                        from all_objects where owner like 'UBD%' or owner='DOCENCIA';
    begin 
        for vfila in crecorre loop 
            dbms_output.put_line(vfila.object_name||'           '|| vfila.object_type||'         '||vfila.owner);
        end loop;
    end;
/

/*
2. Cree una tabla TB_ESTILO con los siguientes atributos: TIPO_OBJETO, PREFIJO. 
En esta tabla se guardan unas normas de estilo de modo que a cada tipo de objeto le corresponde un prefijo en su identificador. 
As� por ejemplo guardamos la tupla ('PROCEDURE','PR_') para indicar que un nombre correcto de procedimiento es PR_HOLA_MUNDO.
*/

create table tb_estilo (tipo_objeto varchar2(50), prefijo varchar2(50));

-- Insertamos los prefijos de procedimientos y vistas

insert into tb_estilo values('PROCEDURE','PR_');
insert into tb_estilo values('VIEW','V_');

--A�ADIMOS DOS ATRIBUTOS ESTADO Y NOMBRE_CORRECTO, AMBOS VARCHAR2(50) EN TB_OBJETOS

/*
3. Cree un procedimiento llamado PR_COMPROBAR(ESQUEMA IN VARCHAR2) que recorre la tabla TB_OBJETOS y comprueba si se
cumplen las normas de estilo seg�n la tabla TB_ESTILO. El par�metro que recibe es el identificador del esquema sobre 
el que queremos comprobar las normas. Si no se especifica, se comprueba en todos. 
Extienda el esquema de la tabla TB_OBJETOS en tres atributos: ESTADO y NOMBRE_CORRECTO de modo que se pueda guardar
si un objeto es CORRECTO o INCORRECTO seg�n las normas de estilo y dando en el caso de que no sea correcto un identificador 
con el prefijo adecuado. El nuevo identificador se calcula anteponiendo el prefijo correcto al identificador antiguo. 
Si el identificador nuevo excede el tama�o del OBJECT_NAME de Oracle, entonces pode el nuevo identificador por la derecha. 
Use un cursor de actualizaci�n para realizar este procedimiento.
*/

-- Creamos el procedimiento PR_COMPROBAR

CREATE OR REPLACE PROCEDURE PR_COMPROBAR 
(
  p_esquema IN VARCHAR2 
  --nombre usuario que pasan al procedimiento 
) AS 
    
    cursor crecorre (pc_esquema varchar2) is select * from tb_objetos where esquema_original = pc_esquema;
    --crea un cursor que selecciona los objetos pertenecientes al usuario que pasan al llamar al cursor
    
BEGIN
      for vfila in crecorre(p_esquema) loop  
            --Hemos llamado al cursor con el usuario que nos pasaron por el procedimiento
            --as� que el cursor seleccinar� los objetos pertenecientes a dicho usuario
           dbms_output.put_line(vfila.nombre);
      end loop;
END PR_COMPROBAR;
/

-- Ejecutamos el procedimiento para el usuario 'DOCENCIA'

execute pr_comprobar('DOCENCIA');

-- Hasta ahora hemos impreso todos los objetos del usuario docencia que est�n en la tabla tb_objetos

-- Ahora vamos a ponerle delante del objeto el prefijo correspondiente a su tipo:

CREATE OR REPLACE PROCEDURE PR_COMPROBAR 
(
  p_esquema IN VARCHAR2 
) AS 
    
    cursor crecorre (pc_esquema varchar2) is select * from tb_objetos where esquema_original = pc_esquema;    
    vprefijo varchar2(50);
    
BEGIN
      for vfila in crecorre(p_esquema) loop
            --seleccionamos el prefijo que tiene el tipo indicado por vfila.tipo 
            select prefijo into vprefijo from tb_estilo where tipo_objeto=vfila.tipo;
            --imprimimos el nombre con su prefijo delante
            dbms_output.put_line(vprefijo||vfila.nombre);
      end loop;
END PR_COMPROBAR;

--NOTA: si el select dentro del procedimiento no obtiene resultados 
--      no devuelve un null, sino que salta excepci�n. Resolv�moslo:

CREATE OR REPLACE PROCEDURE PR_COMPROBAR 
(
  p_esquema IN VARCHAR2 
) AS 
    
    cursor crecorre (pc_esquema varchar2) is select * from tb_objetos where esquema_original = pc_esquema;    
    vprefijo varchar2(50);
    vcuenta number;
    
BEGIN
      for vfila in crecorre(p_esquema) loop
            select count(*) into vcuenta from tb_estilo where tipo_objeto=vfila.tipo;
            --seleccionamos el prefijo que tiene el tipo indicado por vfila.tipo 
            if(vcuenta=1) then
                 select prefijo into vprefijo from tb_estilo where tipo_objeto=vfila.tipo;
                --imprimimos el nombre con su prefijo delante
                dbms_output.put_line(vprefijo||vfila.nombre);
            end if;
      end loop;
END PR_COMPROBAR;

-- Por �ltimo modificamos el procedimiento para actualizar tb_objetos en funci�n
-- de si su nombre ya es el correcto que debr�a llevar y controlar que no sobrepase
-- el tama�o m�ximo definido

create or replace PROCEDURE PR_COMPROBAR 
(
  p_esquema IN VARCHAR2 default null
) AS 
    
    cursor crecorre (pc_esquema varchar2) is select * from tb_objetos where esquema_original = pc_esquema;    
    vprefijo varchar2(50);
    vnombre_correcto varchar2(50);
    vcuenta number;
    
BEGIN
      for vfila in crecorre(p_esquema) loop
            select count(*) into vcuenta from tb_estilo where tipo_objeto=vfila.tipo;
            --seleccionamos el prefijo que tiene el tipo indicado por vfila.tipo 
            if(vcuenta=1) then
                select prefijo into vprefijo from tb_estilo where tipo_objeto=vfila.tipo;
                
                IF INSTR(vfila.nombre, vprefijo) != 1 THEN
                vnombre_correcto := vprefijo || vfila.nombre;
                -- Si el nuevo nombre excede el l�mite, truncarlo 
                -- supongamos que el l�mite est� en tama�o 50
                IF LENGTH(vnombre_correcto) > 50 THEN
                    vnombre_correcto := SUBSTR(vnombre_correcto, 1, 50);
                END IF;
                -- Actualizar los atributos ESTADO y NOMBRE_CORRECTO
                UPDATE tb_objetos
                SET estado = 'INCORRECTO',
                    nombre_correcto = vnombre_correcto
                WHERE nombre = vfila.nombre;
            ELSE
                -- El nombre ya tiene un prefijo, establecer como correcto
                UPDATE tb_objetos
                SET estado = 'CORRECTO'
                WHERE nombre = vfila.nombre;
            END IF;
            end if;
      end loop;
END PR_COMPROBAR;
/
