# As per the usual, no AI was used to create this, either for assistance or code completion.
# 
# I used the following code as a way to implement the "Press ENTER to continue subroutine:
# https://stackoverflow.com/questions/49722074/ddg#55756567

.data
    greeting:   .asciiz "This program generates and shuffles a deck of cards, then deals a deck of five."
    contPrompt: .asciiz "Press ENTER to continue."

.text
main:

    li $v0, 4
    la $a0, greeting
    syscall

    li $v0, 11
    la $a0, '\n'
    syscall

    jal continuePrompt    

    li $v0, 4
    la $a0, confirmDebug

    li $v0, 10
    syscall

generateDeck:


shuffleDeck:


dealCards:


continuePrompt:
    li $v0, 4
    la $a0, contPrompt
    syscall

    li $v0, 12
    syscall

    move $t0, $v0

    li $v0, 11
    la $a0, '\n'
    syscall
      
    bne $t0, 10, continuePrompt

    jr $ra
