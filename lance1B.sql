WHENEVER SQLERROR EXIT FAILURE
rem
rem ===================================================================
rem = Composition du nom du fichier log
rem = Lancement du main du package
rem = MTR
rem ===================================================================
rem
variable Vcode number
define x=0
column x new_value x
set serveroutput on
set termout off
set echo on
set feed off
set head off
spool $UNXLOG/DetailsEnvoi.log
declare
  v_code number := 0; 
  v_date_trait date;
  v_ficlog varchar2(50);
  v_path varchar2(100);
   traitement_erreur exception;
   
begin
    
    SELECT to_date('&1', 'YYYYMMDDHH24MISS'), '&2' INTO v_date_trait, v_path from dual ;
		
    SELECT to_char(sysdate,'YYYYMMDDHH24MI')||'_DetailsEnvoi.log' INTO v_ficlog FROM dual ;


V_code := SCHEMA2.PACKAGE_PXCR95.MAIN_ENVOI_CR95(v_ficlog,v_date_trait,v_path, 'message95.txt'); 

        
        if v_code = 1 then 
                raise traitement_erreur;
        end if;  
        :Vcode := 0;

        exception
        when traitement_erreur then
        :Vcode := 1;
        when others then 
        :Vcode := 1;
end;
/

select :Vcode x from dual;
exit x
/
