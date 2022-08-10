//VERSION PARA HACER DEBUGGING DE FundMe.sol

//FOR THIS COURSE LIMIT TINKERING / TRIAGING (ESTAR ATASCADO EN UN ERROR) TO 20 MINUTES

//SPDX-License-Identifier: MIT

/*
    METODOLOGIA PARA CUANDO HAY UN ERROR O ESTAMOS ATASCADOS

        1.- Emplear 20 minutos en intentar entender cual es el error, ver donde se está produciendo e intentar
            explorar todas las posibles soluciones que se nos ocurran (sin mirar a internet aun)
        
        2.- Google la descripción exacta del error
            (For this course also look in GitHub repo discussions and/or chronological updates

        3.- Check oficial documentation and use ctrl+F to search exactly what you need

        4.- Check github repo for specific version errors

        5.- Ask a question on a forum like stack exchange ETH or stack overflow

        ¿Como formular preguntas?

            ´´´  --> usar 3 de estos delante y detras del código en stack overflow o github para que se vea claramente el codigo en la pregunta
            Copiar y pegar el error que nos esta devolviendo el compilador
        
*/

pragma solidity ^0.8.0;

import "./PriceConverter.sol";

error NotOwner();   

contract FundMe {

    using PriceConverter for uint256;

    uint public constant MINIMUM_USD = 50 * 1e18;    

    address [] public funders;  

    mapping(address=>uint256)public addressToAmountFunded; 

    address public immutable i_owner;       

    constructor(){ 
        i_owner = msg.sender;         
    }

    //probar esta funcion y los errores que se reciben sin tener la keyword de payable

    /*
        TypeError: "msg.value" and "callvalue()" can only be used in payable public functions. Make the function "payable" or use an internal function to avoid this error.
    */
    
    function fund()public /*payable*/{
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
        if (msg.sender != i_owner){revert NotOwner(); }
        _;                                                      
    } 

    
    receive() external payable {    
        fund();
    }     

    fallback() external payable{    
        fund();     
    }
}                               

