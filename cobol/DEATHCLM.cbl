      ******************************************************************
      * PROGRAM : DEATHCLM - DEATH CLAIM / DEATH BENEFIT PAYOUT
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: PROCESSES A DEATH CLAIM. DEATH BENEFIT = GREATER OF
      *           ACCOUNT VALUE OR RETURN OF PREMIUM. NO SURRENDER
      *           CHARGE ON DEATH. SETS STATUS TO DEATH-CLAIM.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DEATHCLM.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       01  WS-DEATH-BENEFIT         PIC 9(11)V99 COMP-3.
       LINKAGE SECTION.
       01  LK-DTH-IN.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-ACCT-VALUE        PIC 9(11)V99.
           05  LK-INITIAL-PREMIUM   PIC 9(09)V99.
           05  LK-DEATH-DATE        PIC 9(08).
       01  LK-DTH-OUT.
           05  LK-DEATH-BENEFIT     PIC 9(11)V99.
           05  LK-FINAL-STATUS      PIC X(01).
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-DTH-IN LK-DTH-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-PROCESS-DEATH
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-POLICY-STATUS = 'S' OR LK-POLICY-STATUS = 'D'
                                     OR LK-POLICY-STATUS = 'M'
               MOVE 'E601' TO LK-RETURN-CODE
               MOVE 'POLICY NOT ELIGIBLE FOR DEATH CLAIM'
                    TO LK-MESSAGE
           END-IF.
       2000-PROCESS-DEATH.
           IF LK-ACCT-VALUE > LK-INITIAL-PREMIUM
               MOVE LK-ACCT-VALUE TO WS-DEATH-BENEFIT
           ELSE
               MOVE LK-INITIAL-PREMIUM TO WS-DEATH-BENEFIT
           END-IF
           MOVE WS-DEATH-BENEFIT TO LK-DEATH-BENEFIT
           MOVE 'D' TO LK-FINAL-STATUS
           MOVE 'DEATH BENEFIT CALCULATED' TO LK-MESSAGE.
