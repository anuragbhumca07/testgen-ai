      ******************************************************************
      * CPYPOLCY - POLICY MASTER COPYBOOK
      * POLICY ADMIN SYSTEM - ANNUITIES
      ******************************************************************
       01  WS-POLICY-RECORD.
           05  PM-POLICY-NUMBER         PIC X(12).
           05  PM-COMPANY-CODE          PIC X(04).
           05  PM-PRODUCT-CODE          PIC X(06).
           05  PM-OWNER-ID              PIC 9(09).
           05  PM-ANNUITANT-ID          PIC 9(09).
           05  PM-ISSUE-DATE            PIC 9(08).
           05  PM-ISSUE-AGE             PIC 9(03).
           05  PM-MATURITY-DATE         PIC 9(08).
           05  PM-POLICY-STATUS         PIC X(01).
               88  PM-PENDING               VALUE 'P'.
               88  PM-INFORCE               VALUE 'I'.
               88  PM-FREE-LOOK             VALUE 'F'.
               88  PM-SURRENDERED           VALUE 'S'.
               88  PM-DEATH-CLAIM           VALUE 'D'.
               88  PM-MATURED               VALUE 'M'.
           05  PM-PLAN-TYPE             PIC X(01).
               88  PM-QUALIFIED             VALUE 'Q'.
               88  PM-NON-QUALIFIED         VALUE 'N'.
           05  PM-INITIAL-PREMIUM       PIC 9(09)V99 COMP-3.
           05  PM-ACCOUNT-VALUE         PIC 9(11)V99 COMP-3.
           05  PM-SURRENDER-VALUE       PIC 9(11)V99 COMP-3.
           05  PM-GUARANTEED-RATE       PIC 9(02)V9(04) COMP-3.
           05  PM-SURR-CHARGE-YR        PIC 9(02).
           05  PM-FREE-LOOK-END-DATE    PIC 9(08).
           05  PM-LAST-TRX-DATE         PIC 9(08).
