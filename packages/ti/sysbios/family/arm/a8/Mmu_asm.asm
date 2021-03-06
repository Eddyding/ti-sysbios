;
;  Copyright (c) 2014, Texas Instruments Incorporated
;  All rights reserved.
; 
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions
;  are met:
; 
;  *  Redistributions of source code must retain the above copyright
;     notice, this list of conditions and the following disclaimer.
; 
;  *  Redistributions in binary form must reproduce the above copyright
;     notice, this list of conditions and the following disclaimer in the
;     documentation and/or other materials provided with the distribution.
; 
;  *  Neither the name of Texas Instruments Incorporated nor the names of
;     its contributors may be used to endorse or promote products derived
;     from this software without specific prior written permission.
; 
;  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
;  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
;  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
;  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
;  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
;  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
;  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
;  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
;  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
;
;
; ======== Mmu_asm.asm ========
;
;

        .cdecls C,NOLIST,"package/internal/Mmu.xdc.h"

    .if __TI_EABI_ASSEMBLER
        .asg ti_sysbios_family_arm_a8_Mmu_init__I, _ti_sysbios_family_arm_a8_Mmu_init__I
        .asg ti_sysbios_family_arm_a8_Mmu_disableAsm__I, _ti_sysbios_family_arm_a8_Mmu_disableAsm__I
        .asg ti_sysbios_family_arm_a8_Mmu_enableAsm__I, _ti_sysbios_family_arm_a8_Mmu_enableAsm__I
        .asg ti_sysbios_family_arm_a8_Mmu_isEnabled__E, _ti_sysbios_family_arm_a8_Mmu_isEnabled__E
        .asg ti_sysbios_family_arm_a8_Mmu_Module__state__V, _ti_sysbios_family_arm_a8_Mmu_Module__state__V
        .asg ti_sysbios_family_arm_a8_Mmu_getAsid__E, _ti_sysbios_family_arm_a8_Mmu_getAsid__E
        .asg ti_sysbios_family_arm_a8_Mmu_getDomainAccessCtrlReg__E, _ti_sysbios_family_arm_a8_Mmu_getDomainAccessCtrlReg__E
        .asg ti_sysbios_family_arm_a8_Mmu_setDomainAccessCtrlReg__E, _ti_sysbios_family_arm_a8_Mmu_setDomainAccessCtrlReg__E
        .asg ti_sysbios_family_arm_a8_Mmu_switchContext__E, _ti_sysbios_family_arm_a8_Mmu_switchContext__E
        .asg ti_sysbios_family_arm_a8_Mmu_tlbInvAll__E, _ti_sysbios_family_arm_a8_Mmu_tlbInvAll__E
    .endif

        .global _ti_sysbios_family_arm_a8_Mmu_init__I
        .global _ti_sysbios_family_arm_a8_Mmu_disableAsm__I
        .global _ti_sysbios_family_arm_a8_Mmu_enableAsm__I
        .global _ti_sysbios_family_arm_a8_Mmu_isEnabled__E
        .global _ti_sysbios_family_arm_a8_Mmu_getAsid__E
        .global _ti_sysbios_family_arm_a8_Mmu_getDomainAccessCtrlReg__E
        .global _ti_sysbios_family_arm_a8_Mmu_setDomainAccessCtrlReg__E
        .global _ti_sysbios_family_arm_a8_Mmu_switchContext__E
        .global _ti_sysbios_family_arm_a8_Mmu_tlbInvAll__E

_ti_sysbios_family_arm_a8_Mmu_Module__state__V .tag ti_sysbios_family_arm_a8_Mmu_Module_State

        .state32
        .align  4

;
; ======== Mmu_init ========
; Initialize mmu registers and asid.
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_init"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_init__I

_ti_sysbios_family_arm_a8_Mmu_init__I
        .asmfunc
        mov r0, #0                      ; TTBR0 used and desc uses Short format
        mcr p15, #0, r0, c2, c0, #2     ; write r0 to TTBCR
        mcr p15, #0, r0, c13, c0, #1    ; init ASID to 0
        isb

        bx r14
        .endasmfunc

;
; ======== Mmu_disableAsm ========
; Disable MMU.
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_disableAsm"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_disableAsm__I

_ti_sysbios_family_arm_a8_Mmu_disableAsm__I
        .asmfunc
        mcr p15, #0, r0, c8, c7, #0     ; invalidate unified TLB
        dsb                             ; wait for invalidation to complete
        isb                             ; flush instruction pipeline
        mrc p15, #0, r0, c1, c0, #0     ; read register c1
        mov r1, #0x1                    ; move #1 into r1
        bic r0, r0, r1                  ; clear bit 1 in r0
        mcr p15, #0, r0, c1, c0, #0     ; mmu disabled (bit 1 = 0)

        bx r14
        .endasmfunc
        
;
; ======== Mmu_enableAsm ========
; Enable MMU.
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_enableAsm"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_enableAsm__I

_ti_sysbios_family_arm_a8_Mmu_enableAsm__I
        .asmfunc
        mcr p15, #0, r1, c8, c7, #0     ; invalidate unified TLB
        dsb                             ; wait for invalidation to complete
        isb                             ; flush instruction pipeline

        ldr r0, tableBuf                ; get page table pointer
        ldr r0, [r0]                    ; get page table address
        mcr p15, #0, r0, c2, c0, #0     ; write TTBR with Module->tableBuf.

        mrc p15, #0, r0, c1, c0, #0     ; read register c1
        mov r1, #0x1                    ; move #1 into r1
        orr r0, r0, r1                  ; OR r1 with r0 into r0
        mcr p15, #0, r0, c1, c0, #0     ; mmu enabled (bit 1 = 1)

        bx r14
        .endasmfunc

tableBuf:
        .word   _ti_sysbios_family_arm_a8_Mmu_Module__state__V.tableBuf

;
; ======== Mmu_isEnabled ========
; Determines if MMU is enabled. Returns TRUE if enabled otherwise FALSE.
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_isEnabled"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_isEnabled__E

_ti_sysbios_family_arm_a8_Mmu_isEnabled__E
        .asmfunc
        mov r0, #0
        mrc p15, #0, r1, c1, c0, #0     ; read register c1 to r1
        tst r1, #0x1                    ; test bit 1
        movne r0, #1                    ; if not 0, MMU is enabled

        bx r14
        .endasmfunc

;
; ======== Mmu_getDomainAccessCtrlReg ========
; Return the contents of DACR register
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_getDomainAccessCtrlReg"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_getDomainAccessCtrlReg__E

_ti_sysbios_family_arm_a8_Mmu_getDomainAccessCtrlReg__E
        .asmfunc
        mrc p15, #0, r0, c3, c0, #0     ; read DACR into r0

        bx r14
        .endasmfunc

;
; ======== Mmu_setDomainAccessCtrlReg ========
; Write the passed argument to DACR register
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_setDomainAccessCtrlReg"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_setDomainAccessCtrlReg__E

_ti_sysbios_family_arm_a8_Mmu_setDomainAccessCtrlReg__E
        .asmfunc
        mcr p15, #0, r0, c3, c0, #0     ; write r0 to DACR

        bx r14
        .endasmfunc

;
;  ======== Mmu_switchContext ========
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_switchContext"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_switchContext__E

_ti_sysbios_family_arm_a8_Mmu_switchContext__E
        .asmfunc
        dmb                              ; ensure all memory accesses complete
        mov     r2, #0xFF
        mcr     p15, #0, r2, c13, c0, #1 ; change ASID to 255
        isb
        mcr     p15, #0, r1, c2, c0, #0  ; write new table address to TTBR
        isb
        mcr     p15, #0, r0, c13, c0, #1 ; change ASID to new value
        isb

        bx      lr
        .endasmfunc

;
;  ======== Mmu_getAsid ========
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_getAsid"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_getAsid__E

_ti_sysbios_family_arm_a8_Mmu_getAsid__E
        .asmfunc
        mrc     p15, #0, r0, c13, c0, #1
        and     r0, r0, #0xFF

        bx      lr
        .endasmfunc

;
; ======== Mmu_tlbInvAll ========
;
        .sect ".text:_ti_sysbios_family_arm_a8_Mmu_tlbInvAll"
        .clink
        .armfunc _ti_sysbios_family_arm_a8_Mmu_tlbInvAll__E

_ti_sysbios_family_arm_a8_Mmu_tlbInvAll__E:
        .asmfunc
        dsb                             ; wait for invalidation to complete
        mcr     p15, #0, r0, c8, c7, #0 ; invalidate unified TLB
        dsb                             ; wait for invalidation to complete
        isb                             ; flush instruction pipeline

        bx      r14
        .endasmfunc
