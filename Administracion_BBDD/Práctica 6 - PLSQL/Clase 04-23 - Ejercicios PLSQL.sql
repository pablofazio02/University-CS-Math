/*

Cree una tabla llamada TB_OBJETOS con los siguientes atributos: . Recorra la vista ALL_OBJECTS y rellene esta tabla con los datos que se aportan en la vista. Use un cursor y no un INSERT.
Cree una tabla TB_ESTILO con los siguientes atributos: TIPO_OBJETO, PREFIJO. En esta tabla se guardan unas normas de estilo de modo que a cada tipo de objeto le corresponde un prefijo en su identificador. Así por ejemplo guardamos la tupla ('PROCEDURE','PR_') para indicar que un nombre correcto de procedimiento es PR_HOLA_MUNDO.
Cree un procedimiento llamado PR_COMPROBAR(ESQUEMA IN VARCHAR2) que recorre la tabla TB_OBJETOS y comprueba si se cumplen las normas de estilo según la tabla TB_ESTILO. El parámetro que recibe es el identificador del esquema sobre el que queremos comprobar las normas. Si no se especifica, se comprueba en todos. Extienda el esquema de la tabla TB_OBJETOS en tres atributos: ESTADO y NOMBRE_CORRECTO de modo que se pueda guardar si un objeto es CORRECTO o INCORRECTO según las normas de estilo y dando en el caso de que no sea correcto un identificador con el prefijo adecuado. El nuevo identificador se calcula anteponiendo el prefijo correcto al identificador antiguo. Si el identificador nuevo excede el tamaño del OBJECT_NAME de Oracle, entonces pode el nuevo identificador por la derecha. Use un cursor de actualización para realizar este procedimiento.

*/

create table tb_objetos (
NOMBRE varchar2(50), CODIGO number , FECHA_CREACION date , FECHA_MODIFICACION date , TIPO varchar(50), ESQUEMA_ORIGINAL varchar(50));

select * from all_objects;


--Salen muchos así que vamos a usar únicamente la info de los owner UBD% y DOCENCIA
select object_name, object_id, created, last_ddl_time, object_type, owner from all_objects where owner like 'UBD%' or owner='DOCENCIA';

--se podría hacer así
insert into tb_objetos 
select object_name, object_id, created, last_ddl_time, object_type, owner from all_objects where owner like 'UBD%' or owner='DOCENCIA';

--vamos a volver a hacerlo con cursores, así que vaciamos la tabla:
delete tb_objetos; --borra los datos de la tabla (y hay rollback)
truncate table tb_objetos; --borra los datos de la tabla y no se puede hacer rollback


--ahora la rellenamos con cursores
declare
    cursor crecorre is select object_name, object_id, created, last_ddl_time, object_type, owner 
                        from all_objects where owner like 'UBD%' or owner='DOCENCIA';
    begin 
        for vfila in crecorre loop 
            insert into tb_objetos values vfila;
        end loop;
    end;
/

--si queremos imprimir la lista de objetos (en vez de meterla en la tabla):
set  serveroutput on;

declare
    cursor crecorre is select object_name, object_id, created, last_ddl_time, object_type, owner 
                        from all_objects where owner like 'UBD%' or owner='DOCENCIA';
    begin 
        for vfila in crecorre loop 
            dbms_output.put_line(vfila.object_name||'           '|| vfila.object_type||'         '||vfila.owner);
        end loop;
    end;
/

-------EJERCICIO 2


create table tb_estilo (tipo_objeto varchar2(50), prefijo varchar2(50));

insert into tb_estilo values('PROCEDURE','PR_');
insert into tb_estilo values('VIEW','V_');


--AÑADIMOS DOS ATRIBUTOS ESTADO Y NOMBRE_CORRECTO, AMBOS VARCHAR2(50) EN TB_OBJETOS



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
            --así que el cursor seleccinará los objetos pertenecientes a dicho usuario
           dbms_output.put_line(vfila.nombre);
      end loop;
END PR_COMPROBAR;
/


--ejecutamos el procedimiento para el usuario 'DOCENCIA'
DECLARE
  P_ESQUEMA VARCHAR2(200);
BEGIN
  P_ESQUEMA := 'DOCENCIA';

  PR_COMPROBAR(P_ESQUEMA => P_ESQUEMA); --rollback; 
END;
/

--Es igual a hacer 
execute pr_comprobar('DOCENCIA');

--hasta ahora hemos impreso todos los objetos del usuario docencia que están en la tabla tb_objetos

--Ahora vamos a ponerle delante del objeto el prefijo correspondiente a su tipo:


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
--      no devuelve un null, sino que salta excepción. Resolvámoslo:


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

