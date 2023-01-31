
const artefacto = artifacts.require("Adoption");

module.exports = async function() {
    instancia= await artefacto.deployed();
    adoptadores= await instancia.getAdopters();
    console.log(adoptadores);
};