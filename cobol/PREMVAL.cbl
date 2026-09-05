      ******************************************************************
      * PROGRAM : PREMVAL  - PREMIUM / SUITABILITY VALIDATION UTILITY
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: SHARED UTILITY CALLED BY ISSUE AND PAYMENT MODULES.
      *           VALIDATES A PREMIUM AGAINST BAND LIMITS AND RETURNS
      *           A SUITABILITY FLAG BASED ON AGE / PREMIUM RATIO.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PREMVAL.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-RATIO                 PIC 9(05)V99 COMP-3.
       LINKAGE SECTION.
       01  LK-PV-IN.
           05  LK-PREMIUM           PIC 9(11)V99.
           05  LK-MIN-PREM          PIC 9(09)V99.
           05  LK-MAX-PREM          PIC 9(11)V99.
           05  LK-ISSUE-AGE         PIC 9(03).
           05  LK-NET-WORTH         PIC 9(11)V99.
       01  LK-PV-OUT.
           05  LK-VALID-FLAG        PIC X(01).
           05  LK-SUITABILITY-FLAG  PIC X(01).
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-PV-IN LK-PV-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE 'Y' TO LK-VALID-FLAG
           MOVE 'Y' TO LK-SUITABILITY-FLAG
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-CHECK-BANDS
           IF LK-VALID-FLAG = 'Y'
               PERFORM 2000-CHECK-SUITABILITY
           END-IF
           GOBACK.
       1000-CHECK-BANDS.
           IF LK-PREMIUM < LK-MIN-PREM OR LK-PREMIUM > LK-MAX-PREM
               MOVE 'N' TO LK-VALID-FLAG
               MOVE 'E901' TO LK-RETURN-CODE
               MOVE 'PREMIUM OUTSIDE ALLOWED BAND' TO LK-MESSAGE
           END-IF.
       2000-CHECK-SUITABILITY.
      *    SUITABILITY: PREMIUM SHOULD NOT EXCEED 50% OF NET WORTH
           IF LK-NET-WORTH > 0
               COMPUTE WS-RATIO = LK-PREMIUM / LK-NET-WORTH
               IF WS-RATIO > 0.50
                   MOVE 'N' TO LK-SUITABILITY-FLAG
                   MOVE 'E902' TO LK-RETURN-CODE
                   MOVE 'PREMIUM EXCEEDS 50 PCT OF NET WORTH'
                        TO LK-MESSAGE
               END-IF
           ELSE
               MOVE 'N' TO LK-SUITABILITY-FLAG
               MOVE 'E903' TO LK-RETURN-CODE
               MOVE 'NET WORTH REQUIRED FOR SUITABILITY'
                    TO LK-MESSAGE
           END-IF.
