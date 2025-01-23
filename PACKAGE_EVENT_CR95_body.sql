create or replace PACKAGE BODY PACKAGE_EVENT_CR95 AS

  FUNCTION ALIM_EVENT_CR95(NOMLOG        VARCHAR2,
                          P_DATE_TRAI   DATE,
                          V_INSERTS     OUT NUMBER,
                          V_Updates     OUT NUMBER,
                          V_Error       OUT VARCHAR2) RETURN NUMBER AS
        V_ERR   NUMBER := 0;	
        V_INS   NUMBER := 0;   
        V_UPD   NUMBER := 0;	

        
        FILE_ID UTL_FILE.FILE_TYPE;  
        Res     Number := 0; 
        V_Mois Number;
        V_Annee Number;
        V_DATE_SITU date;
        
        V_COUNT NUMBER;
        
        CURSOR C_CR95 IS 
            SELECT  
                    DATE_CLE AS DATE_CLE,
                    ID_CLE AS ID_CLE,
                    CR_SOLDE AS CR_SOLDE  
                    
            FROM SCHEMA2.TAB_TEMP_CR95
            WHERE ((GR_ID = 8 AND TYPE_EVENT != 'CR') OR GR_ID != 8   ) ;
                    

    BEGIN

        FILE_ID := SCHEMA1.PACKAGE_PROPEN.F_OPEN(NOMLOG); 
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_EVENT_CR95','## Alimentation de la table TAB_DEF_CR95  ##'); 
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_EVENT_CR95','## Flux TAB_TEMP_CR95   ##');


        
        SELECT trunc(P_DATE_TRAI, 'MM') - 1 INTO V_DATE_SITU FROM dual;
        Select To_Number(To_Char(V_DATE_SITU,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_DATE_SITU,'YYYY'))   INTO V_ANNEE  from dual;
		
                
    
        
        FOR S_CR95 IN C_CR95  LOOP  
     
            BEGIN

                IF V_ERR=1 THEN EXIT;  
                END IF;

                IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
                END IF;

                INSERT INTO SCHEMA1.TAB_DEF_CR95  
                    (
                    REF_PERIOD,
                    DATE_CLE,
                    ID_CLE,
                    SOLDE,
                    FLAG			
                    )
                VALUES
                    (   
                    TO_CHAR(ADD_MONTHS(S_CR95.DATE_CLE, -1),'YYYYMM'),  
                    S_CR95.DATE_CLE,
                    S_CR95.ID_CLE,
                    S_CR95.CR_SOLDE,
                    'N'
                    );   
                         

                V_INS := V_INS + 1;

                
            EXCEPTION

                WHEN DUP_VAL_ON_INDEX THEN
                UPDATE  SCHEMA1.TAB_DEF_CR95     
                SET     
                    
                    REF_PERIOD	    =   TO_CHAR(ADD_MONTHS(S_CR95.DATE_CLE, -1),'YYYYMM'),                     
                    SOLDE		    =   S_CR95.CR_SOLDE,
                    FLAG		    =   'N' 
                    Where ID_CLE		=   S_CR95.ID_CLE
                    AND DATE_CLE		=   S_CR95.DATE_CLE;
                        							
            
                V_UPD := V_UPD + 1;

            
                WHEN OTHERS THEN  
                    COMMIT;   
                    V_ERR := 1;

                    
                    V_ERROR := SUBSTR('SQLCODE: '||TO_CHAR(SQLCODE)||' -ERROR: '||SQLERRM,1,4000);   
                    RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_EVENT_CR95','Message Erreur pl/sql :'||SQLERRM,'E');
                        
                RETURN V_ERR;
            END;
        END LOOP;

        COMMIT;

        V_INSERTS := V_INS;
        V_UPDATES := V_UPD;
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_EVENT_CR95','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
        

        
        UTL_FILE.FCLOSE(FILE_ID);
        RETURN V_ERR;
    --End;



  END ALIM_EVENT_CR95;



	FUNCTION MAIN_EVENT_CR95 (NOMLOG       VARCHAR2, P_DATE_TRAI   DATE) RETURN NUMBER IS

		V_RET NUMBER := 0;                   

	    V_INSERTS   NUMBER := 0;			
		V_UPDATES   NUMBER := 0;			
		V_ERROR   VARCHAR2(255);  		

		V_ERR   NUMBER := 0;


        BEGIN
            
			V_ERR     := ALIM_EVENT_CR95( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

			RETURN V_RET;
		

	END MAIN_EVENT_CR95;




END PACKAGE_EVENT_CR95;