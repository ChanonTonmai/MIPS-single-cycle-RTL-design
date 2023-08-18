# MIPS-single-cycle-RTL-design
This hardware and design are supported this group of instuction set architecture:
|-------|-------|------|---------|--------|--------|------|-------|
|  MULT |  ADD  |  LUI |   SUB   |   BEQ  | BLTZAL | JALR | SLTIU |
| MULTU |  ADDI |  LW  |   SUBU  |  BGEZ  |   BNE  |  JR  |  SLTU |
|  NOR  | ADDIU | MFHI |    SW   | BGEZAL |   DIV  |  LB  |  SRA  |
|   OR  |  ADDU | MFLO | SYSCALL |  BGTZ  |  DIVU  |  LBU |  SRAV |
|  ORI  |  AND  | MTHI |   XOR   |  BLEZ  |    J   |  LH  |  SRL  |
|   SB  |  ANDI | MTLO |   XORI  |  BLTZ  |   JAL  |  LHU |  SRLV |
|   SH  |  SLL  | SLLV |   SLT   |  SLTI  |        |      |       |

The hardware design are designed as the figure below: 
![alt text](./pic/MIPS.drawio.png)