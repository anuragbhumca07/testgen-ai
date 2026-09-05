      ******************************************************************
      * PROGRAM : COMPSET  - INSURANCE COMPANY / CARRIER SETUP
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: VALIDATES AND ESTABLISHES A NEW CARRIER / COMPANY
      *           IN THE ADMIN SYSTEM WITH PRODUCT-LINE RULES.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPSET.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYCOMPY.
       01  WS-RETURN-CODE           PIC X(04) VALUE SPACES.
       01  WS-MSG                   PIC X(60) VALUE SPACES.
       LINKAGE SECTION.
       01  LK-COMPANY-IN.
           05  LK-COMPANY-CODE      PIC X(04).
           05  LK-COMPANY-NAME      PIC X(40).
           05  LK-CARRIER-ID        PIC 9(06).
           05  LK-NAIC-CODE         PIC 9(05).
           05  LK-STATE-DOMICILE    PIC X(02).
           05  LK-PRODUCT-LINE      PIC X(01).
           05  LK-EFFECTIVE-DATE    PIC 9(08).
           05  LK-MIN-PREMIUM       PIC 9(09)V99.
           05  LK-MAX-PREMIUM       PIC 9(11)V99.
           05  LK-MIN-ISSUE-AGE     PIC 9(03).
           05  LK-MAX-ISSUE-AGE     PIC 9(03).
       01  LK-RESULT.
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-COMPANY-IN LK-RESULT.
       0000-MAIN.
           MOVE '0000' TO WS-RETURN-CODE
           MOVE SPACES TO WS-MSG
           PERFORM 1000-VALIDATE-INPUT
           IF WS-RETURN-CODE = '0000'
               PERFORM 2000-ESTABLISH-COMPANY
           END-IF
           MOVE WS-RETURN-CODE TO LK-RETURN-CODE
           MOVE WS-MSG         TO LK-MESSAGE
           GOBACK.
       1000-VALIDATE-INPUT.
           IF LK-COMPANY-CODE = SPACES
               MOVE 'E001' TO WS-RETURN-CODE
               MOVE 'COMPANY CODE IS MANDATORY' TO WS-MSG
           ELSE
               IF LK-PRODUCT-LINE NOT = 'F' AND
                  LK-PRODUCT-LINE NOT = 'V' AND
                  LK-PRODUCT-LINE NOT = 'I'
                   MOVE 'E002' TO WS-RETURN-CODE
                   MOVE 'INVALID PRODUCT LINE' TO WS-MSG
               ELSE
                   IF LK-MIN-PREMIUM > LK-MAX-PREMIUM
                       MOVE 'E003' TO WS-RETURN-CODE
                       MOVE 'MIN PREMIUM EXCEEDS MAX' TO WS-MSG
                   ELSE
                       IF LK-MIN-ISSUE-AGE > LK-MAX-ISSUE-AGE
                           MOVE 'E004' TO WS-RETURN-CODE
                           MOVE 'MIN AGE EXCEEDS MAX AGE' TO WS-MSG
                       END-IF
                   END-IF
               END-IF
           END-IF.
       2000-ESTABLISH-COMPANY.
           MOVE LK-COMPANY-CODE   TO CO-COMPANY-CODE
           MOVE LK-COMPANY-NAME   TO CO-COMPANY-NAME
           MOVE LK-CARRIER-ID     TO CO-CARRIER-ID
           MOVE LK-PRODUCT-LINE   TO CO-PRODUCT-LINE
           MOVE 'A'               TO CO-STATUS
           MOVE 30                TO CO-FREE-LOOK-DAYS
           MOVE 'CARRIER ESTABLISHED SUCCESSFULLY' TO WS-MSG.
