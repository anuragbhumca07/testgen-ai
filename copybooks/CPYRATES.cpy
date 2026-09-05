      ******************************************************************
      * CPYRATES - SURRENDER CHARGE / RATE TABLE COPYBOOK
      * POLICY ADMIN SYSTEM - ANNUITIES
      ******************************************************************
       01  WS-SURR-CHARGE-TABLE.
           05  SC-PRODUCT-CODE          PIC X(06).
           05  SC-CHARGE-SCHEDULE OCCURS 10 TIMES
                                        INDEXED BY SC-IDX.
               10  SC-POLICY-YEAR       PIC 9(02).
               10  SC-CHARGE-PCT        PIC 9(02)V9(04) COMP-3.
           05  SC-FREE-WD-PCT           PIC 9(02)V9(04) COMP-3.
           05  SC-MVA-APPLICABLE        PIC X(01).
               88  SC-MVA-YES               VALUE 'Y'.
               88  SC-MVA-NO                VALUE 'N'.
