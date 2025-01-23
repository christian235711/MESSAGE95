create or replace PACKAGE BODY   PACKAGE_PXCR95 AS

  FUNCTION ALIM_CR95(    NOMLOG        VARCHAR2,
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
        
        V_ANNEE_TMP NUMBER;
        V_MOIS_TMP NUMBER;
        V_CHARGE NUMBER;
        
        V_MAX_PERIOD VARCHAR2(6);
        
        V_MOIS_ATTENDU NUMBER;
        V_ANNEE_ATTENDU NUMBER;
      
        
        CURSOR C_CR151 IS 

        SELECT  *
  
        FROM SCHEMA2.TAB_TEMP_PXCR95;     

    BEGIN

        FILE_ID := SCHEMA1.PACKAGE_PROPEN.F_OPEN(NOMLOG); 
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','## Alimentation de la table TAB_DEF_PXCR95  ##'); 
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','## Flux TAB_TEMP_PXCR95   ##');

        BEGIN
        SELECT DISTINCT to_number(SUBSTR(DATE_CLE,1,4)), to_number(SUBSTR(DATE_CLE,5,2))
        INTO V_ANNEE_TMP, V_MOIS_TMP
        FROM SCHEMA2.TAB_TEMP_PXCR95;
      EXCEPTION WHEN OTHERS THEN
            V_ANNEE_TMP :=NULL;
            V_MOIS_TMP := NULL;
            RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','ERROR V_ANNEE_TMP - V_MOIS_TMP'); 
        RETURN 1;
      END;
        
        SELECT trunc(P_DATE_TRAI, 'MM') - 1 INTO V_DATE_SITU FROM dual;
        Select To_Number(To_Char(V_DATE_SITU,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_DATE_SITU,'YYYY'))   INTO V_ANNEE  from dual;
		
        -------------------------------------------
        BEGIN
        
          SELECT COUNT(*)
          INTO V_CHARGE
          FROM SCHEMA3.TAB_DEF_PXCR95 
          WHERE DATE_CLE=  REPLACE(TO_CHAR(V_ANNEE_TMP, '0000') || TO_CHAR(V_MOIS_TMP, '00'), ' ', '');
      EXCEPTION WHEN OTHERS THEN
                V_CHARGE :=NULL;
                RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','ERROR V_CHARGE'); 
            RETURN 1;
        END;
        
        IF V_CHARGE >0 THEN
                 RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','ALIMENTATION KO');
                 RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','PERIODE DEJA CHARAGEE');
                  V_ERR := 1;
                RETURN V_ERR;
        END IF ;
        
        ---------------------------------------------
        
        BEGIN
            SELECT MAX(DATE_CLE)
            INTO   V_MAX_PERIOD
            FROM   SCHEMA3.TAB_DEF_PXCR95;
        EXCEPTION WHEN OTHERS THEN
            V_MAX_PERIOD := NULL;
            RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','ERROR V_MAX_PERIOD'); 
        END;
        
        IF V_MAX_PERIOD IS NULL THEN 
            V_MOIS_ATTENDU := V_Mois;
            V_ANNEE_ATTENDU := V_ANNEE;
        END IF;
        
        -----------------------------------------------
        
        IF V_MAX_PERIOD IS NOT NULL THEN
            V_ANNEE_ATTENDU := SUBSTR(V_MAX_PERIOD, 1, 4);
            V_MOIS_ATTENDU := SUBSTR(V_MAX_PERIOD, 5, 2);
            
            IF V_MOIS_ATTENDU = 12 THEN
                V_MOIS_ATTENDU := 1;
                V_ANNEE_ATTENDU := V_ANNEE_ATTENDU +1;
            ELSE
                V_MOIS_ATTENDU := V_MOIS_ATTENDU +1;
            END IF;
        END IF;     
        
        
        IF V_ANNEE_ATTENDU != V_ANNEE_TMP OR V_MOIS_ATTENDU != V_MOIS_TMP  THEN 
                    RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','ALIMENTATION KO');
                    RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','DATE_CLE NON CONFORME');
                    V_ERR := 1;
                    RETURN V_ERR;
        END IF;            
    
        
        FOR S_CR151 IN C_CR151  LOOP  
     
            BEGIN

                IF V_ERR=1 THEN EXIT;  
                END IF;

                IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
                END IF;

                INSERT INTO SCHEMA3.TAB_DEF_PXCR95  
                    (
                    DATE_CLE, -- 6car
                    CODE_AB,
                    CODE_F1,
                    CODE_F2,
                    CODE_TX,
                    CODE_CT,
                    CODE_FN,
                    ID_CLE,
                    FINAN_VAL,
                    VAL_UST
                    )
                VALUES
                    (   
                    S_CR151.DATE_CLE,
                    S_CR151.CODE_AB,
                    S_CR151.CODE_F1,
                    S_CR151.CODE_F2,
                    S_CR151.CODE_TX,
                    S_CR151.CODE_CT,
                    S_CR151.CODE_FN,
                    S_CR151.ID_CLE,
                    S_CR151.FINAN_VAL,
                    S_CR151.VAL_UST
                    );   
                         

                V_INS := V_INS + 1;

                
            EXCEPTION

                WHEN DUP_VAL_ON_INDEX THEN
                UPDATE  SCHEMA3.TAB_DEF_PXCR95     
                SET     
                    
                    CODE_AB			=   S_CR151.CODE_AB,
                    CODE_F1			=   S_CR151.CODE_F1,
                    CODE_F2		    =   S_CR151.CODE_F2,
                    CODE_TX		    =   S_CR151.CODE_TX,
                    CODE_CT		    =   S_CR151.CODE_CT,
                    CODE_FN		    =   S_CR151.CODE_FN,
                    FINAN_VAL		=   S_CR151.FINAN_VAL,
                    VAL_UST		    =   S_CR151.VAL_UST
                    Where DATE_CLE		=   S_CR151.DATE_CLE
                    AND ID_CLE		    =   S_CR151.ID_CLE;
                        							
            
                V_UPD := V_UPD + 1;

            
                WHEN OTHERS THEN  
                    COMMIT;   
                    V_ERR := 1;

                    
                    V_ERROR := SUBSTR('SQLCODE: '||TO_CHAR(SQLCODE)||' -ERROR: '||SQLERRM,1,4000);   
                    RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','Message Erreur pl/sql :'||SQLERRM,'E');
                        
                RETURN V_ERR;
            END;
        END LOOP;

        COMMIT;

        V_INSERTS := V_INS;
        V_UPDATES := V_UPD;
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
        

        UTL_FILE.FCLOSE(FILE_ID);
        RETURN V_ERR;
    --End;



  end ALIM_CR95; 
  
  
  FUNCTION ALIM_CR95_INIT(      NOMLOG        VARCHAR2,
                          P_DATE_TRAI   DATE,
                          V_INSERTS     OUT NUMBER,
                          V_Updates     OUT NUMBER,
                          V_Error       OUT VARCHAR2) RETURN NUMBER AS
        V_ERR   NUMBER := 0;	
        V_INS   NUMBER := 0;   
        V_UPD   NUMBER := 0;	
        V_UPD_1   NUMBER := 0;
            
        FILE_ID UTL_FILE.FILE_TYPE;  
        Res     Number := 0; 
        V_Mois Number;
        V_Annee Number;
        V_DATE_SITU date;
        
        V_MT_SOLDE_COM NUMBER(18,3);
        V_LAST_EVT_SITUATION DATE;



        CURSOR C_CR151 IS 

        SELECT  PXCR95.ID_CLE,
                nek.MONTANT_SOLDE,
                NEK_DATE_SITUATION,
                PXCR95.DATE_CLE
        FROM    SCHEMA3.TAB_DEF_PXCR95 PXCR95, SCHEMA1.TAB_DEF_NEK nek
        WHERE   SUBSTR(PXCR95.DATE_CLE,1,4) = to_char(trunc(P_DATE_TRAI, 'MM') - 1,'YYYY') 
        AND     SUBSTR(PXCR95.DATE_CLE,5,2) = To_Char(trunc(P_DATE_TRAI, 'MM') - 1,'MM') 
        AND     nek_code_pays = 'X'
        AND     NEK_ID_CLE = replace(PXCR95.ID_CLE, ' ', '')
        AND     nek.nek_date_situation = (SELECT MAX(EK2.NEK_DATE_SITUATION)
                                          FROM   SCHEMA1.TAB_DEF_NEK EK2
                                          WHERE  EK2.NEK_CODE_PAYS = NEK.NEK_CODE_PAYS
                                          AND    EK2.NEK_ID_CLE = NEK.NEK_ID_CLE
                                          AND    EK2.NEK_DATE_SITUATION <= P_DATE_TRAI
                                          AND    EK2.NEK_DATE_SITUATION >= trunc(P_DATE_TRAI, 'mm'));

    BEGIN

        FILE_ID := SCHEMA1.PACKAGE_PROPEN.F_OPEN(NOMLOG); 
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_INIT','## Initialisation de la table TAB_DEF_PXCR95  ##'); 
    
        
        FOR S_CR151 IN C_CR151  LOOP  
     
            
                
                V_MT_SOLDE_COM := NULL;
                V_LAST_EVT_SITUATION      := NULL;
                
                BEGIN
                    SELECT PX_SOLDE_COM, LAST_EVT_SITUATION
                    INTO   V_MT_SOLDE_COM, V_LAST_EVT_SITUATION
                    FROM   SCHEMA3.TAB_DEF_PXCR95 PXCR95
                    WHERE  SUBSTR(PXCR95.DATE_CLE,1,4) = to_char(trunc(P_DATE_TRAI, 'MM') - 1,'YYYY') 
                    AND    SUBSTR(PXCR95.DATE_CLE,5,2) = To_Char(trunc(P_DATE_TRAI, 'MM') - 1,'MM') 
                    AND    PXCR95.ID_CLE = S_CR151.ID_CLE;
                EXCEPTION WHEN OTHERS THEN
                    V_MT_SOLDE_COM := NULL;
                    V_LAST_EVT_SITUATION      := NULL;
                END;
                
                    
              
                IF (s_cr151.MONTANT_SOLDE < V_MT_SOLDE_COM AND  V_MT_SOLDE_COM >0) OR V_MT_SOLDE_COM IS NULL  THEN
                
                BEGIN
                UPDATE  SCHEMA3.TAB_DEF_PXCR95 
                SET     
               
                    PX_SOLDE_COM = s_cr151.MONTANT_SOLDE,
                    FLAG_ENVOI_DELTA        = 'Y',
                    LAST_EVT_SITUATION      = s_cr151.NEK_DATE_SITUATION
                    WHERE       ID_CLE  =   S_CR151.ID_CLE
                    AND         DATE_CLE  =   S_CR151.DATE_CLE
                    ;
                V_UPD := V_UPD + 1;

            
                EXCEPTION WHEN OTHERS THEN  
                    COMMIT;   
                    V_ERR := 1;

                    
                    V_ERROR := SUBSTR('SQLCODE: '||TO_CHAR(SQLCODE)||' -ERROR: '||SQLERRM,1,4000);   
                    RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_INIT','Message Erreur pl/sql :'||SQLERRM,'E');
                        
                RETURN V_ERR;
                
            END;
            END IF;
        END LOOP;
        COMMIT;

        V_INSERTS := V_INS;
        V_UPDATES := V_UPD;
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_INIT','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
                
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_INIT','Nombre de mises a jour de TAB_DEF_PXCR95 : '  || TO_CHAR(V_UPD_1) );

        
        UTL_FILE.FCLOSE(FILE_ID);
        RETURN V_ERR;
    --End;



  END ALIM_CR95_INIT;
  
  
  


  FUNCTION ALIM_CR95_MESSAGE(      NOMLOG        VARCHAR2,
                          P_DATE_TRAI   DATE,
                          V_INSERTS     OUT NUMBER,
                          V_Updates     OUT NUMBER,
                          V_Error       OUT VARCHAR2) RETURN NUMBER AS
        V_ERR   NUMBER := 0;	
        V_INS   NUMBER := 0;   
        V_UPD   NUMBER := 0;	
        V_UPD_1   NUMBER := 0;
            
        FILE_ID UTL_FILE.FILE_TYPE;  
        Res     Number := 0; 
        V_Mois Number;
        V_Annee Number;
        V_DATE_SITU date;
        
        V_Mois_1 Number;
        V_Annee_1 Number;
        V_DATE_SITU_1 date;
        V_Mois_2 Number;
        V_Annee_2 Number;
        V_DATE_SITU_2 date;
        V_COUNT NUMBER;
        V_PERIOD_M VARCHAR2(1);
        V_PERIOD_M_1 VARCHAR2(1);
        V_PERIOD_M_2 VARCHAR2(1);
        
        V_SOLDE_COM NUMBER(18,3);
        V_EVENT_PERIOD_T SCHEMA3.TAB_DEF_PX_MESSAGE.EVENT_PERIOD_T%TYPE;




        CURSOR C_CR151 IS 

        SELECT  
                    CASE WHEN SUM(PXCR95.PX_SOLDE_COM) > 0  THEN 'A'
                         ELSE  'B'
                        END AS PERIODE,
                    PXCR95.DATE_CLE,   
                    PXCR95.CODE_AB,
                    PXCR95.CODE_F1,
                    PXCR95.CODE_F2,
                    PXCR95.CODE_TX,
                    PXCR95.CODE_CT,
                    PXCR95.CODE_FN,
                    PXCR95.FINAN_VAL,
                    PXCR95.VAL_UST
        FROM   SCHEMA3.TAB_DEF_PXCR95 PXCR95
        WHERE SUBSTR(PXCR95.DATE_CLE,1,4) = to_char(trunc(P_DATE_TRAI, 'MM') - 1,'YYYY') 
        AND   SUBSTR(PXCR95.DATE_CLE,5,2) = To_Char(trunc(P_DATE_TRAI, 'MM') - 1,'MM') 
        AND   FLAG_ENVOI_DELTA = 'Y'
        GROUP BY    PXCR95.DATE_CLE,     
                    PXCR95.CODE_AB,
                    PXCR95.CODE_F1,
                    PXCR95.CODE_F2,
                    PXCR95.CODE_TX,
                    PXCR95.CODE_CT,
                    PXCR95.CODE_FN,
                    PXCR95.FINAN_VAL,
                    PXCR95.VAL_UST
        ;     

    BEGIN

        FILE_ID := SCHEMA1.PACKAGE_PROPEN.F_OPEN(NOMLOG); 
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_MESSAGE','## Alimentation de la table TAB_DEF_PX_MESSAGE  ##'); 


    
        SELECT trunc(P_DATE_TRAI, 'MM') - 1 INTO V_DATE_SITU FROM dual;  --20XX06
        Select To_Number(To_Char(V_DATE_SITU,'MM')) Into V_Mois From Dual ;
        SELECT to_number(to_char(V_DATE_SITU,'YYYY'))   INTO V_ANNEE  from dual;
               
        SELECT trunc(V_DATE_SITU, 'MM') - 1 INTO V_DATE_SITU_1 FROM dual;  --20XX05
        Select To_Number(To_Char(V_DATE_SITU_1,'MM')) Into V_Mois_1 From Dual ;
        SELECT to_number(to_char(V_DATE_SITU_1,'YYYY'))   INTO V_ANNEE_1  from dual;
        
        SELECT trunc(V_DATE_SITU_1, 'MM') - 1 INTO V_DATE_SITU_2 FROM dual;  --20XX04
        Select To_Number(To_Char(V_DATE_SITU_2,'MM')) Into V_Mois_2 From Dual ;
        SELECT to_number(to_char(V_DATE_SITU_2,'YYYY'))   INTO V_ANNEE_2  from dual;   
    
        
        FOR S_CR151 IN C_CR151  LOOP  
     
                BEGIN  
                    SELECT DISTINCT 'Y'                
                    INTO V_PERIOD_M_1
                    FROM SCHEMA3.TAB_DEF_PXCR95
                    WHERE CODE_AB = S_CR151.CODE_AB
                    AND CODE_F1 = S_CR151.CODE_F1
                    AND CODE_F2 = S_CR151.CODE_F2
                    AND TO_NUMBER(SUBSTR(DATE_CLE,1,4))  = V_ANNEE_1
                    AND TO_NUMBER(SUBSTR(DATE_CLE,5,2)) = V_Mois_1;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    V_PERIOD_M_1 := 'N';
                        WHEN OTHERS THEN
                    V_PERIOD_M_1 := 'N';
                END;                


                BEGIN  
                    SELECT DISTINCT 'Y'
                    INTO V_PERIOD_M_2
                    FROM SCHEMA3.TAB_DEF_PXCR95
                    WHERE CODE_AB = S_CR151.CODE_AB
                    AND CODE_F1 = S_CR151.CODE_F1
                    AND CODE_F2 = S_CR151.CODE_F2
                    AND TO_NUMBER(SUBSTR(DATE_CLE,1,4))  = V_ANNEE_2
                    AND TO_NUMBER(SUBSTR(DATE_CLE,5,2)) = V_Mois_2;
               EXCEPTION WHEN NO_DATA_FOUND THEN
                    V_PERIOD_M_2 := 'N';
                        WHEN OTHERS THEN
                    V_PERIOD_M_2 := 'N';
                END;    


                IF V_ERR=1 THEN EXIT;  
                END IF;

                IF MOD(V_UPD + V_INS, 100)=0 THEN COMMIT;
                END IF;
                
                
                V_SOLDE_COM := NULL;
                -----------------------------------------
                -- VERIF AU NIVEAU DU CLIENT
                -- SI SOLDE_COMPTABLE > 0 ALORS P
                -- SINON T
                -----------------------------------------
                BEGIN
                SELECT  SUM(nek.MONTANT_SOLDE)
                INTO    V_SOLDE_COM
                FROM    SCHEMA3.TAB_DEF_PXCR95 PXCR95, SCHEMA1.TAB_DEF_NEK nek
                WHERE   SUBSTR(PXCR95.DATE_CLE,1,4) = to_char(trunc(P_DATE_TRAI, 'MM') - 1,'YYYY') 
                AND     SUBSTR(PXCR95.DATE_CLE,5,2) = To_Char(trunc(P_DATE_TRAI, 'MM') - 1,'MM') 
                AND     nek_code_pays = 'X'
                AND     NEK_ID_CLE = replace(PXCR95.ID_CLE, ' ', '')
                AND     CODE_AB = S_CR151.CODE_AB
                AND     CODE_F1 = S_CR151.CODE_F1
                AND     CODE_F2 = S_CR151.CODE_F2
                AND     nek.nek_date_situation = (SELECT MAX(EK2.NEK_DATE_SITUATION)
                                                    FROM   SCHEMA1.TAB_DEF_NEK EK2
                                                    WHERE  EK2.NEK_CODE_PAYS = NEK.NEK_CODE_PAYS
                                                    AND    EK2.NEK_ID_CLE = NEK.NEK_ID_CLE
                                                    AND    EK2.NEK_DATE_SITUATION <= P_DATE_TRAI);
               EXCEPTION WHEN OTHERS THEN
               V_SOLDE_COM := NULL;
               END;
               

               IF V_SOLDE_COM > 0 THEN
                    V_PERIOD_M := 'A';
               ELSE 
                    V_PERIOD_M := 'B';
               END IF;
                
                
                IF V_PERIOD_M_1 = 'Y' THEN V_PERIOD_M_1 := V_PERIOD_M; END IF;
                IF V_PERIOD_M_2 = 'Y' THEN V_PERIOD_M_2 := V_PERIOD_M; END IF;
                
                
                ------------------------------
                -- VERIFICATION SI LE MESSAGE EXISTE DEJA EN CAS DE RENVOI d'un EVEN
                -- MEME SI EVEN RENVOI UN EVT, LE SOLDE PEUT ETRE A 0 ALORS QU IL L ETAIT DEJA SUR DES EVT DU MEME MOIS
                ------------------------------
                
                BEGIN
                    SELECT EVENT_PERIOD_T
                    INTO   V_EVENT_PERIOD_T
                    FROM   SCHEMA3.TAB_DEF_PX_MESSAGE
                    WHERE  DATE_CLE = S_CR151.DATE_CLE
                    AND    CODE_AB  = S_CR151.CODE_AB
                    AND    CODE_F1  = S_CR151.CODE_F1
                    AND    CODE_F2  = S_CR151.CODE_F2;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                            V_EVENT_PERIOD_T := 'N';
                          WHEN OTHERS THEN
                           V_EVENT_PERIOD_T := 'N';
                          
                END;
                
                
                BEGIN
                INSERT INTO SCHEMA3.TAB_DEF_PX_MESSAGE 
                    (
                    DATE_CLE,
                    CODE_AB,
                    CODE_F1,
                    CODE_F2,
                    ELABORATION_DATE,
                    CODE_CT,
                    CODE_FN,
                    CHAMPS_TP,
                    EVENT_PERIOD_T,
                    EVENT_PERIOD_T_1,
                    EVENT_PERIOD_T_2,
                    FLAG_ENVOI_DELTA,
                    DATE_ENVOI
                    )
                VALUES
                    (
                    S_CR151.DATE_CLE,
                    S_CR151.CODE_AB,
                    S_CR151.CODE_F1,
                    S_CR151.CODE_F2,
                    SYSDATE,
                    S_CR151.CODE_CT,
                    S_CR151.CODE_FN,
                    'X',
                    V_PERIOD_M,
                    V_PERIOD_M_1,
                    V_PERIOD_M_2,
                    'Y',
                    P_DATE_TRAI
                    );   
                         

                V_INS := V_INS + 1;

                
            EXCEPTION

                WHEN DUP_VAL_ON_INDEX THEN
                UPDATE  SCHEMA3.TAB_DEF_PX_MESSAGE    
                SET     
               
                    ELABORATION_DATE = SYSDATE,
                    CODE_CT          = S_CR151.CODE_CT,
                    CODE_FN          = S_CR151.CODE_FN,
                    CHAMPS_TP        = 'X',
                    EVENT_PERIOD_T   = V_PERIOD_M,
                    EVENT_PERIOD_T_1 = V_PERIOD_M_1,
                    EVENT_PERIOD_T_2 = V_PERIOD_M_2,
                    FLAG_ENVOI_DELTA      = 'Y',
                    DATE_ENVOI            = P_DATE_TRAI
                    WHERE       CODE_AB	  =   S_CR151.CODE_AB
                    AND         CODE_F1   =	S_CR151.CODE_F1		
                    AND         CODE_F2   =   S_CR151.CODE_F2
                    AND         DATE_CLE  =   S_CR151.DATE_CLE
                    ;
                V_UPD := V_UPD + 1;

            
                WHEN OTHERS THEN  
                    COMMIT;   
                    V_ERR := 1;
                    V_ERROR := SUBSTR('SQLCODE: '||TO_CHAR(SQLCODE)||' -ERROR: '||SQLERRM,1,4000);   
                    RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_MESSAGE','Message Erreur pl/sql :'||SQLERRM,'E');
                        
                RETURN V_ERR;
            END;
            
            
        END LOOP;

        COMMIT;
        
        UPDATE  SCHEMA3.TAB_DEF_PXCR95 PXCR95
        SET     FLAG_ENVOI_DELTA = 'N'
        WHERE   SUBSTR(PXCR95.DATE_CLE,1,4) = to_char(trunc(P_DATE_TRAI, 'MM') - 1,'YYYY')
        AND     SUBSTR(PXCR95.DATE_CLE,5,2) = To_Char(trunc(P_DATE_TRAI, 'MM') - 1,'MM');
        COMMIT;

        V_INSERTS := V_INS;
        V_UPDATES := V_UPD;
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_MESSAGE','Nombre de mises a jour : '||TO_CHAR(V_UPD)||', d''insertions : '||TO_CHAR(V_INS));
                
        RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'ALIM_CR95_MESSAGE','Nombre de mises a jour de TAB_DEF_PXCR95 : '  || TO_CHAR(V_UPD_1) );

        
        
        UTL_FILE.FCLOSE(FILE_ID);
        RETURN V_ERR;
    --End;



  END ALIM_CR95_MESSAGE;


  

  FUNCTION EXPORT_CR95_MESSAGE(NOMLOG	VARCHAR2, P_DATE_TRAI DATE, P_PATH    VARCHAR2, P_FILENAME  VARCHAR2) RETURN NUMBER AS

    V_ERR                NUMBER := 0;
    N_SAUV               NUMBER:=0;
    v_ligne         VARCHAR2(4000);
    file_id_cvs     utl_file.file_type;
    file_name       VARCHAR2(30);

    FILE_ID   UTL_FILE.FILE_TYPE;
    RES       NUMBER := 0;

    CURSOR C_REC Is
        SELECT 
                   DATE_CLE                                 AS DATE_CLE,
                   CODE_AB                                  AS CODE_AB,
                   CODE_F1                                  AS CODE_F1      ,
                   CODE_F2                                  AS CODE_F2  ,
                   TO_CHAR(ELABORATION_DATE, 'YYYYMMDD')    AS ELABORATION_DATE ,
                   CODE_CT                                  AS CODE_CT     ,
                   CODE_FN                                  AS CODE_FN    ,
                   CHAMPS_TP                                AS CHAMPS_TP  ,
                   EVENT_PERIOD_T                           AS EVENT_PERIOD_T,
                   EVENT_PERIOD_T_1                         AS EVENT_PERIOD_T_1  ,
                   EVENT_PERIOD_T_2                         AS EVENT_PERIOD_T_2
        
          FROM SCHEMA3.TAB_DEF_PX_MESSAGE
          WHERE TO_NUMBER(SUBSTR(DATE_CLE,1,4)) = to_char(trunc(P_DATE_TRAI, 'MM') - 1,'YYYY')
          AND   TO_NUMBER(SUBSTR(DATE_CLE,5,2)) = To_Char(trunc(P_DATE_TRAI, 'MM') - 1,'MM')
          AND   FLAG_ENVOI_DELTA = 'Y';
   

	BEGIN
    file_name := p_filename;
    FILE_ID := SCHEMA1.PACKAGE_PROPEN.F_OPEN(NOMLOG);
    file_id_cvs:= SCHEMA1.PACKAGE_PROPEN.F_OPEN_CVS(p_path,file_name);
    RES     := SCHEMA1.PACKAGE_PROPEN.F_WRITE(FILE_ID, 'EXPORT_CR95_MESSAGE', ' ## MISE A DISPOSITION du fichier ##');

    --V_LIGNE := '';
    --RES := SCHEMA1.PACKAGE_PROPEN.F_WRITE_CVS (file_id_cvs, V_LIGNE);
  FOR REC IN C_REC LOOP

      BEGIN
           IF V_ERR=1 THEN
              EXIT;
           END IF;
                       V_LIGNE :=
                    REC.CODE_AB            || 
                    REC.CODE_F1            || 
                    REC.CODE_F2            || 
                    REC.ELABORATION_DATE   || 
                    REC.CODE_CT            || 
                    REC.CODE_FN            ||
                    REC.CHAMPS_TP          ||
                    REC.EVENT_PERIOD_T     || 
                    REC.EVENT_PERIOD_T_1   ||
                    REC.EVENT_PERIOD_T_2                     
                       ;
                       
                            


    res := SCHEMA1.PACKAGE_PROPEN.F_WRITE_CVS(file_id_cvs, v_ligne);
    
            UPDATE SCHEMA3.TAB_DEF_PX_MESSAGE
            SET     FLAG_ENVOI_DELTA = 'N'
            WHERE  DATE_CLE = REC.DATE_CLE
            AND    CODE_AB   = REC.CODE_AB
            AND    CODE_F1   = REC.CODE_F1
            AND    CODE_F2   = REC.CODE_F2;

            N_SAUV := N_SAUV + 1;
			EXCEPTION
            WHEN OTHERS THEN
                COMMIT;
                V_ERR  := 1;
                res     := SCHEMA1.PACKAGE_PROPEN.F_WRITE(file_id,
                                          'EXPORT_CR95_MESSAGE ',
                                         'Message Erreur pl/sql : ' ||
                                         SQLERRM );
                RETURN V_ERR;
      END;
  END LOOP;
  COMMIT;


	UTL_FILE.FCLOSE(file_id_cvs);

   res := SCHEMA1.PACKAGE_PROPEN.F_WRITE(file_id, 'EXPORT_CR95_MESSAGE', 'Nombre de lignes ?crites :' || N_SAUV);


    UTL_FILE.FCLOSE(file_id);

    RETURN V_ERR;

    EXCEPTION WHEN OTHERS THEN
          COMMIT;
          V_ERR  := 1;

          res     := SCHEMA1.PACKAGE_PROPEN.F_WRITE(file_id,
                                          'EXPORT_CR95_MESSAGE',
                                         'Message Erreur pl/sql : ' ||
                                         SQLERRM);
          RETURN V_ERR;

  END EXPORT_CR95_MESSAGE;










	FUNCTION MAIN_CR95 (NOMLOG        VARCHAR2,
                         P_DATE_TRAI   DATE) RETURN NUMBER IS

		V_RET NUMBER := 0;                   

	    V_INSERTS   NUMBER := 0;			
		V_UPDATES   NUMBER := 0;			
		V_ERROR   VARCHAR2(255);  		

		V_ERR   NUMBER := 0;


        BEGIN
	
			V_ERR     := ALIM_CR95( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;
            
			V_ERR     := ALIM_CR95_INIT( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


			RETURN V_RET;
		

	END MAIN_CR95;



	FUNCTION MAIN_ENVOI_CR95 (NOMLOG            VARCHAR2,
                                P_DATE_TRAI   DATE,
                                P_PATH        VARCHAR2,                             
                                P_FILENAME    VARCHAR2) RETURN NUMBER IS

		V_RET NUMBER := 0;                   

	    V_INSERTS   NUMBER := 0;			
		V_UPDATES   NUMBER := 0;			
		V_ERROR   VARCHAR2(255);  		

		V_ERR   NUMBER := 0;


        BEGIN

			V_ERR     := ALIM_CR95_INIT( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;
        
		---------------
			V_ERR     := ALIM_CR95_MESSAGE( NOMLOG, P_DATE_TRAI, V_INSERTS, V_UPDATES, V_ERROR );
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;

        ---------------
			V_ERR     := EXPORT_CR95_MESSAGE(NOMLOG, P_DATE_TRAI, P_PATH, P_FILENAME);
			IF V_ERR = 1 THEN
				V_RET := 1;
				RETURN V_RET;
			END IF;


			RETURN V_RET;

		

	END MAIN_ENVOI_CR95;


  
  
    
END PACKAGE_PXCR95;