// SPDX-License-Identifier: MIT
pragma solidity >0.7.0 <0.9.0;

contract semaphore {

    enum Sem {
        verde, rojo
    }

    Sem private Semaforo;

    constructor() {
        Semaforo = Sem.rojo;
    }
// 1->0 5466
// 0->1 22537
// bool true, false => 0 y 1
// uint8 1,2 

    function setSemaforo() public{
        if(Semaforo==Sem.rojo) {
            Semaforo = Sem.verde;
        } else {
            Semaforo= Sem.rojo;
        }
    }

    function getSemaforo() public view returns(Sem) {
        return(Semaforo);
    }

}