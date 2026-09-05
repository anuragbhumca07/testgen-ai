      ******************************************************************
      * PROGRAM : TERMTRX  - TERMINATING TRANSACTION (FULL SURRENDER)
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: PROCESSES A FULL SURRENDER (TERMINATION). COMPUTES
      *           SURRENDER CHARGE ON FULL ACCOUNT VALUE, TAX FOR
      *           QUALIFIED PLANS, SETS POLICY STATUS TO SURRENDERED.
      *           FREE-LOOK SURRENDER RETURNS FULL PREMIUM, NO CHARGE.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TERMTRX.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       COPY CPYTRANS.
       01  WS-SURR-CHARGE          PIC 9(09)V99 COMP-3.
       01  WS-TAXABLE-AMT          PIC 9(11)V99 COMP-3.
       01  WS-TAX-RATE             PIC 9V9(04) COMP-3 VALUE 0.1000.
       LINKAGE SECTION.
       01  LK-TERM-IN.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-PLAN-TYPE         PIC X(01).
           05  LK-ACCT-VALUE        PIC 9(11)V99.
           05  LK-INITIAL-PREMIUM   PIC 9(09)V99.
           05  LK-SURR-CHARGE-PCT   PIC 9(02)V9(04).
           05  LK-SURR-DATE         PIC 9(08).
       01  LK-TERM-OUT.
           05  LK-SURR-CHARGE-OUT   PIC 9(09)V99.
           05  LK-TAX-WITHHELD      PIC 9(09)V99.
           05  LK-NET-PROCEEDS      PIC 9(11)V99.
           05  LK-FINAL-STATUS      PIC X(01).
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-TERM-IN LK-TERM-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           MOVE ZEROES TO LK-SURR-CHARGE-OUT LK-TAX-WITHHELD
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-PROCESS-SURRENDER
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-POLICY-STATUS = 'S' OR LK-POLICY-STATUS = 'D'
                                     OR LK-POLICY-STATUS = 'M'
               MOVE 'E501' TO LK-RETURN-CODE
               MOVE 'POLICY ALREADY TERMINATED' TO LK-MESSAGE
           ELSE
               IF LK-ACCT-VALUE <= 0
                   MOVE 'E502' TO LK-RETURN-CODE
                   MOVE 'NO VALUE TO SURRENDER' TO LK-MESSAGE
               END-IF
           END-IF.
       2000-PROCESS-SURRENDER.
           IF LK-POLICY-STATUS = 'F'
      *        FREE-LOOK SURRENDER - FULL REFUND OF PREMIUM, NO CHARGE
               MOVE ZEROES TO LK-SURR-CHARGE-OUT
               MOVE ZEROES TO LK-TAX-WITHHELD
               MOVE LK-INITIAL-PREMIUM TO LK-NET-PROCEEDS
               MOVE 'FREE-LOOK SURRENDER - FULL PREMIUM REFUNDED'
                    TO LK-MESSAGE
           ELSE
               COMPUTE WS-SURR-CHARGE ROUNDED =
                       LK-ACCT-VALUE * LK-SURR-CHARGE-PCT
               MOVE WS-SURR-CHARGE TO LK-SURR-CHARGE-OUT
               IF LK-PLAN-TYPE = 'Q'
                   COMPUTE WS-TAXABLE-AMT =
                           LK-ACCT-VALUE - WS-SURR-CHARGE
                   COMPUTE LK-TAX-WITHHELD ROUNDED =
                           WS-TAXABLE-AMT * WS-TAX-RATE
               END-IF
               COMPUTE LK-NET-PROCEEDS =
                   LK-ACCT-VALUE - LK-SURR-CHARGE-OUT - LK-TAX-WITHHELD
               MOVE 'FULL SURRENDER PROCESSED' TO LK-MESSAGE
           END-IF
           MOVE 'S' TO LK-FINAL-STATUS.
