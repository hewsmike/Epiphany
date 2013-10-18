/*
    Copyright (C) 2013 by Mike Hewson
    hewsmike@iinet.net.au

    A collection of assembler macros intended for use with the GNU
    derived 'e-as' software from the Epiphany SDK,
    see <http://www.adapteva.com/announcements/the-new-epiphany-sdk-5-release/>.

    This is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published
    by the Free Software Foundation, version 2 of the License.

    This is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    If you don't have a copy of, the GNU General Public License,
    see <http://www.gnu.org/licenses/>.
*/

/*
    Macro name : mov_long_immed_to_general_reg
    Purpose : to move a 32-bit immediate value to a general register

    Arguments : 'register' - a general register mnemonic
                           - default value = R1
                'immediate' - a literal to be interpreted as a 32-bit value
                            - default value = 0x00000000

    Registers affected : that specified in the 'register' argument field or R1 if not.

    Side effects : none.
*/
.macro  mov_long_immed_to_general_reg register=R1, immediate=0x00000000
    mov \register, %low(\immediate);
    movt \register, %high(\immediate);
.endm

/*
    Macro name : mov_long_immed_to_special_reg
    Purpose : to move a 32-bit immediate value to a special register

    Arguments : 'special_register' - a special register mnemonic
                                   - default value = none ( value required )
                'immediate' - a literal to be interpreted as a 32-bit value
                            - default value = 0x00000000

    Registers affected : that specified in the 'special_register' argument field
                         R1

    Side effects : none.
*/
.macro  mov_long_immed_to_special_reg special_register:req, immediate=0x00000000
    mov_long_immed_to_general_reg R1, \immediate
    movts \special_register, R1;
.endm

/*
    Macro name : hardware_loop_prolog
    Purpose : set up a hardware loop

    Arguments : 'loop_start' - label denoting the beginning of a loop
                             - default value = none ( value required )
                'loop_end' - label denoting the finish of a loop
                           - default value = none ( value required )
                'loop_count' - the number of desired loop iterations
                             - default value = none ( value required )

    Registers affected : R1, LS, LE, LC

    Side effects : gid
                 : pad filling with NOP ( 0x01A2 ) to double word align 
*/
.macro hardware_loop_prolog loop_start:req, loop_end:req, loop_count:req
    mov_long_immed_to_special_reg LS, \loop_start
    mov_long_immed_to_special_reg LE, \loop_end
    mov_long_immed_to_special_reg LC, #\loop_count
    gid;
    .balignw 8, 0x01A2;
    \loop_start:
.endm

/*
    Macro name : hardware_loop_epilog
    Purpose : finalise a hardware loop

    Arguments : none

    Registers affected : none

    Side effects : gie
*/
.macro hardware_loop_epilog
    gie;
.endm
