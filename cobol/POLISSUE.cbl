      ******************************************************************
      * PROGRAM : POLISSUE - NEW POLICY ISSUE
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: ISSUES A NEW ANNUITY POLICY. VALIDATES ISSUE AGE,
      *           PREMIUM LIMITS, PLAN TYPE, AND SETS FREE-LOOK WINDOW.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. POLISSUE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       COPY CPYCOMPY.
       01  WS-CALC-MATURITY-AGE     PIC 9(03) VALUE 100.
       01  WS-YEARS-TO-MATURITY     PIC 9(03).
       LINKAGE SECTION.
       01  LK-ISSUE-IN.
           05  LK-COMPANY-CODE      PIC X(04).
           05  LK-PRODUCT-CODE      PIC X(06).
           05  LK-OWNER-ID          PIC 9(09).
           05  LK-ANNUITANT-ID      PIC 9(09).
           05  LK-ISSUE-DATE        PIC 9(08).
           05  LK-ISSUE-AGE         PIC 9(03).
           05  LK-PLAN-TYPE         PIC X(01).
           05  LK-INITIAL-PREMIUM   PIC 9(09)V99.
           05  LK-CO-MIN-AGE        PIC 9(03).
           05  LK-CO-MAX-AGE        PIC 9(03).
           05  LK-CO-MIN-PREM       PIC 9(09)V99.
           05  LK-CO-MAX-PREM       PIC 9(11)V99.
           05  LK-CO-FREELOOK-DAYS  PIC 9(03).
       01  LK-ISSUE-OUT.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-FREE-LOOK-END     PIC 9(08).
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-ISSUE-IN LK-ISSUE-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-ISSUE-POLICY
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-ISSUE-AGE < LK-CO-MIN-AGE
               MOVE 'E101' TO LK-RETURN-CODE
               MOVE 'ISSUE AGE BELOW MINIMUM' TO LK-MESSAGE
           ELSE
             IF LK-ISSUE-AGE > LK-CO-MAX-AGE
               MOVE 'E102' TO LK-RETURN-CODE
               MOVE 'ISSUE AGE ABOVE MAXIMUM' TO LK-MESSAGE
             ELSE
               IF LK-INITIAL-PREMIUM < LK-CO-MIN-PREM
                 MOVE 'E103' TO LK-RETURN-CODE
                 MOVE 'PREMIUM BELOW MINIMUM' TO LK-MESSAGE
               ELSE
                 IF LK-INITIAL-PREMIUM > LK-CO-MAX-PREM
                   MOVE 'E104' TO LK-RETURN-CODE
                   MOVE 'PREMIUM ABOVE MAXIMUM' TO LK-MESSAGE
                 ELSE
                   IF LK-PLAN-TYPE NOT = 'Q' AND LK-PLAN-TYPE NOT = 'N'
                     MOVE 'E105' TO LK-RETURN-CODE
                     MOVE 'INVALID PLAN TYPE' TO LK-MESSAGE
                   END-IF
                 END-IF
               END-IF
             END-IF
           END-IF.
       2000-ISSUE-POLICY.
           MOVE LK-COMPANY-CODE     TO PM-COMPANY-CODE
           MOVE LK-PRODUCT-CODE     TO PM-PRODUCT-CODE
           MOVE LK-OWNER-ID         TO PM-OWNER-ID
           MOVE LK-ANNUITANT-ID     TO PM-ANNUITANT-ID
           MOVE LK-ISSUE-DATE       TO PM-ISSUE-DATE
           MOVE LK-ISSUE-AGE        TO PM-ISSUE-AGE
           MOVE LK-PLAN-TYPE        TO PM-PLAN-TYPE
           MOVE LK-INITIAL-PREMIUM  TO PM-INITIAL-PREMIUM
           MOVE LK-INITIAL-PREMIUM  TO PM-ACCOUNT-VALUE
           MOVE 'F'                 TO PM-POLICY-STATUS
           COMPUTE WS-YEARS-TO-MATURITY =
                   WS-CALC-MATURITY-AGE - LK-ISSUE-AGE
           MOVE 'F'                 TO LK-POLICY-STATUS
           MOVE 'POL00000001'       TO LK-POLICY-NUMBER
           COMPUTE LK-FREE-LOOK-END =
                   LK-ISSUE-DATE + LK-CO-FREELOOK-DAYS
           MOVE 'POLICY ISSUED - IN FREE LOOK PERIOD' TO LK-MESSAGE.
