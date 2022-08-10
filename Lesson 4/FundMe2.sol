//VERSION MEJORADA Y CON CONCEPTOS MAS AVANZADOS DE FundMe.sol

//SPDX-License-Identifier: MIT

/*
    Coste gas inicial de crear: 988,693 gas
    Coste gas añadiendo constant: 966,227 gas
    Coste gas final de crear: 939,249 gas

    Trucos para reducir el coste:
        -constant keyword
        -immutable keyword

    La razon por la cual estas declaraciones ahorran gas es porque se almacenan directamente en el byte code del
    contrato y hacen que este sea mas ligero (en tamaño) por lo que se requiere menos capacidad computacional para 
    procesar el contrato

    Ademas, tambien podemos mejorar los require. Cada string que se almacena para lanzarse si no se cumple un require 
    ocupa mucho mas espacio que si los almacenamos como constantes en una funcion

    Esto es una nomenclatura muy reciente y aun vamos a ver muchos require dentro de codigos que encontremos


*/

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();   //al declarar el error aquí, nos libramos de tener que escribirlo dentro del contrato, de ahi viene el ahorra de espacio

contract FundMe {

    using PriceConverter for uint256;

    uint public constant MINIMUM_USD = 50 * 1e18;     //solo se declara una vez ==> gasta gas innecesario

    /*
        al añadir constant, esta variable ya no ocupa un espacio de storage entero y es mas eficiente
        
        1.- coste sin constant: 23,515 gas
        2.- coste con constant: 21,415 gas

        Real-time gas average: 10 gwei
        
        USD cost 1: 23,515 * 10000000000 = 235,150,000,000,000 = 0,00023515 eth = 0,39$ 
        USD cost 2: 21,415 * 10000000000 = 214,150,000,000,000 = 0,00021415 eth = 0,36$

        Ahora la diferencia es de 3 centimos, pero cuando eth estaba a 3000$ y el average gas era 140 gwei la diferencia en llamar
        a minimum_USD  era de casi 1$

    */

    address [] public funders;  

    mapping(address=>uint256)public addressToAmountFunded; 

    address public immutable i_owner;       //solo se utiliza una vez (la primera vez que se ejecuta el codigo) ==> gasta gas innecesario

    //variables que declaramos y solo usamos una vez fuera de su declaración las podemos declarar como immutable para ahorrar gas
    //

    constructor(){ 
        i_owner = msg.sender;         
    }

     function fund()public payable{
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didnt send enough");   
        funders.push(msg.sender); 
        addressToAmountFunded[msg.sender] += msg.value;  
    }

    function withdraw()public onlyi_owner{

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){      
            address funder = funders[funderIndex];                                      
            addressToAmountFunded[funder] = 0;   
        }  

        funders = new address [](0);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");           
        require (callSuccess, "Call failed!");
    }    

    modifier onlyi_owner(){
        //require (msg.sender == i_owner, "Sender is not i_owner");
        if (msg.sender != i_owner){revert NotOwner(); }
        _;                                                      
    } 

    // What happens if someone sends this contract ETH without calling the fund function

    receive() external payable {    //special functions
        fund();     //con esta funcion automaticamente hacemos que si alguien envie eth sin usar la función de fund capte la transacción el contrato y la ejecute como un fund
    }

    fallback() external payable{    //special functions
        fund();     //con esta funcion automaticamente hacemos que si alguien envie eth sin usar la función de fund capte la transacción el contrato y la ejecute como un fund
    }
}                               

