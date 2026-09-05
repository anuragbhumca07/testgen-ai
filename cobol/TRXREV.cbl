      ******************************************************************
      * PROGRAM : TRXREV   - TRANSACTION REVERSAL
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: REVERSES A PREVIOUSLY POSTED TRANSACTION. VALIDATES
      *           THAT TRX IS POSTED (NOT ALREADY REVERSED/REJECTED)
      *           AND WITHIN THE ALLOWED REVERSAL WINDOW.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRXREV.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYTRANS.
       01  WS-DATE-DIFF             PIC S9(08).
       01  WS-MAX-REV-DAYS          PIC 9(03) VALUE 90.
       LINKAGE SECTION.
       01  LK-REV-IN.
           05  LK-ORIG-TRX-ID       PIC 9(12).
           05  LK-ORIG-TRX-STATUS   PIC X(01).
           05  LK-ORIG-TRX-AMOUNT   PIC S9(11)V99.
           05  LK-ORIG-TRX-DATE     PIC 9(08).
           05  LK-CURRENT-DATE      PIC 9(08).
       01  LK-REV-OUT.
           05  LK-REV-TRX-AMOUNT    PIC S9(11)V99.
           05  LK-NEW-TRX-STATUS    PIC X(01).
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-REV-IN LK-REV-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-REVERSE
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-ORIG-TRX-STATUS = 'R'
               MOVE 'E701' TO LK-RETURN-CODE
               MOVE 'TRANSACTION ALREADY REVERSED' TO LK-MESSAGE
           ELSE
               IF LK-ORIG-TRX-STATUS = 'X'
                   MOVE 'E702' TO LK-RETURN-CODE
                   MOVE 'CANNOT REVERSE REJECTED TRX' TO LK-MESSAGE
               ELSE
                   COMPUTE WS-DATE-DIFF =
                       LK-CURRENT-DATE - LK-ORIG-TRX-DATE
                   IF WS-DATE-DIFF > WS-MAX-REV-DAYS
                       MOVE 'E703' TO LK-RETURN-CODE
                       MOVE 'REVERSAL WINDOW EXPIRED' TO LK-MESSAGE
                   END-IF
               END-IF
           END-IF.
       2000-REVERSE.
           COMPUTE LK-REV-TRX-AMOUNT = LK-ORIG-TRX-AMOUNT * -1
           MOVE 'R' TO LK-NEW-TRX-STATUS
           MOVE 'TRANSACTION REVERSED SUCCESSFULLY' TO LK-MESSAGE.
