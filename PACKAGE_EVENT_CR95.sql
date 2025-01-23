create or replace PACKAGE PACKAGE_EVENT_CR95 AS 

FUNCTION ALIM_EVENT_CR95(NOMLOG        VARCHAR2,
                          P_DATE_TRAI   DATE,
                          V_INSERTS     OUT NUMBER,
                          V_Updates     OUT NUMBER,
                          V_Error       OUT VARCHAR2) RETURN NUMBER;
                                  
                                  
FUNCTION MAIN_EVENT_CR95(NOMLOG      VARCHAR2,
                         P_DATE_TRAI DATE) RETURN NUMBER;                          
                                                          

                        
END PACKAGE_EVENT_CR95;