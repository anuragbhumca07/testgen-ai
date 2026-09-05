      ******************************************************************
      * CPYCOMPY - INSURANCE COMPANY / CARRIER SETUP COPYBOOK
      * POLICY ADMIN SYSTEM - ANNUITIES
      ******************************************************************
       01  WS-COMPANY-RECORD.
           05  CO-COMPANY-CODE          PIC X(04).
           05  CO-COMPANY-NAME          PIC X(40).
           05  CO-CARRIER-ID            PIC 9(06).
           05  CO-NAIC-CODE             PIC 9(05).
           05  CO-STATE-DOMICILE        PIC X(02).
           05  CO-PRODUCT-LINE          PIC X(01).
               88  CO-FIXED-ANNUITY         VALUE 'F'.
               88  CO-VARIABLE-ANNUITY      VALUE 'V'.
               88  CO-INDEXED-ANNUITY       VALUE 'I'.
           05  CO-EFFECTIVE-DATE        PIC 9(08).
           05  CO-STATUS                PIC X(01).
               88  CO-ACTIVE                VALUE 'A'.
               88  CO-SUSPENDED             VALUE 'S'.
               88  CO-TERMINATED            VALUE 'T'.
           05  CO-MIN-PREMIUM           PIC 9(09)V99 COMP-3.
           05  CO-MAX-PREMIUM           PIC 9(11)V99 COMP-3.
           05  CO-MAX-ISSUE-AGE         PIC 9(03).
           05  CO-MIN-ISSUE-AGE         PIC 9(03).
           05  CO-FREE-LOOK-DAYS        PIC 9(03).
