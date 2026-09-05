      ******************************************************************
      * PROGRAM : PAYMENT  - PREMIUM PAYMENT POSTING
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: POSTS A PREMIUM PAYMENT TO AN INFORCE POLICY,
      *           UPDATES ACCOUNT VALUE. REJECTS IF POLICY NOT ELIGIBLE.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PAYMENT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       COPY CPYTRANS.
       LINKAGE SECTION.
       01  LK-PAY-IN.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-CURR-ACCT-VALUE   PIC 9(11)V99.
           05  LK-PAY-AMOUNT        PIC 9(09)V99.
           05  LK-PAY-DATE          PIC 9(08).
           05  LK-CO-MAX-PREM       PIC 9(11)V99.
       01  LK-PAY-OUT.
           05  LK-NEW-ACCT-VALUE    PIC 9(11)V99.
           05  LK-TRX-AMOUNT        PIC 9(09)V99.
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-PAY-IN LK-PAY-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-POST-PAYMENT
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-POLICY-STATUS = 'S' OR LK-POLICY-STATUS = 'D'
                                     OR LK-POLICY-STATUS = 'M'
               MOVE 'E201' TO LK-RETURN-CODE
               MOVE 'POLICY NOT ELIGIBLE FOR PAYMENT' TO LK-MESSAGE
           ELSE
               IF LK-PAY-AMOUNT <= 0
                   MOVE 'E202' TO LK-RETURN-CODE
                   MOVE 'PAYMENT AMOUNT MUST BE POSITIVE' TO LK-MESSAGE
               ELSE
                   IF LK-CURR-ACCT-VALUE + LK-PAY-AMOUNT >
                      LK-CO-MAX-PREM
                       MOVE 'E203' TO LK-RETURN-CODE
                       MOVE 'PAYMENT EXCEEDS MAX PREMIUM LIMIT'
                            TO LK-MESSAGE
                   END-IF
               END-IF
           END-IF.
       2000-POST-PAYMENT.
           COMPUTE LK-NEW-ACCT-VALUE =
                   LK-CURR-ACCT-VALUE + LK-PAY-AMOUNT
           MOVE LK-PAY-AMOUNT TO LK-TRX-AMOUNT
           MOVE 'PAYMENT POSTED SUCCESSFULLY' TO LK-MESSAGE.
