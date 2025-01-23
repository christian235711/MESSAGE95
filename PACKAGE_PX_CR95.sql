create or replace PACKAGE        PACKAGE_PXCR95 AS 

FUNCTION ALIM_CR95(      NOMLOG        VARCHAR2,
                          P_DATE_TRAI   DATE,
                          V_INSERTS     OUT NUMBER,
                          V_Updates     OUT NUMBER,
                          V_Error       OUT VARCHAR2) RETURN NUMBER;
                          
  FUNCTION ALIM_CR95_INIT(NOMLOG        VARCHAR2,
                          P_DATE_TRAI   DATE,
                          V_INSERTS     OUT NUMBER,
                          V_Updates     OUT NUMBER,
                          V_Error       OUT VARCHAR2) RETURN NUMBER;
                                  
                        
                        
FUNCTION ALIM_CR95_MESSAGE(    NOMLOG        VARCHAR2,
                                P_DATE_TRAI   DATE,
                                V_INSERTS     OUT NUMBER,
                                V_Updates     OUT NUMBER,
                                V_Error       OUT VARCHAR2) RETURN NUMBER;
                                                                                            
                        
                        
FUNCTION EXPORT_CR95_MESSAGE(  NOMLOG	      VARCHAR2,
                                P_DATE_TRAI	  DATE,
                                P_PATH        VARCHAR2,
                                P_FILENAME    VARCHAR2) RETURN NUMBER;
                        

FUNCTION MAIN_CR95(NOMLOG        VARCHAR2,
                   P_DATE_TRAI   DATE) RETURN NUMBER;      


FUNCTION MAIN_ENVOI_CR95(    NOMLOG        VARCHAR2,
                                P_DATE_TRAI   DATE,
                                P_PATH        VARCHAR2,
                                P_FILENAME    VARCHAR2) RETURN NUMBER;                          
                        
                        
END PACKAGE_PXCR95;