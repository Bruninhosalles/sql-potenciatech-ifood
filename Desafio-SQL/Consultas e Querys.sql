use ecommerce;

-- Primeiro nome, sobrenome e CPF de clientes pessoa física.
SELECT Fname, Lname, CPF
FROM clients
WHERE clientType = 'PF';

-- Primeiro nome, sobrenome e CNPJ de clientes pessoa jurídica.
SELECT Fname, Lname, CNPJ
FROM clients
WHERE clientType = 'PJ';

-- Contando todos os clientes.
SELECT COUNT(*) FROM clients;

-- Pedidos confirmados
SELECT Fname, Lname, CPF
FROM clients
WHERE idClient IN (
    SELECT idClient
    FROM request
    WHERE status = 'confirmado'
);
-- Selecionando todos os clientes.
select distinct concat(Fname,' ',Minit,' ',Lname) as Client from clients;

-- Nome do produto, categoria e a classificação.
SELECT Pname, category, rating
FROM product;

-- lista dos pedidos com cliente e pagamentos
select  concat(Fnome,' ',Minit,' ',LName) as Client, r.description, r.status, p.typePayment, p.valor 
		from clients c, request r, payments p 	
        where c.idClient = r.idClient and p.idPayment = r.idPayment;



-- Verificando se existe algum vendedor que também é fornecedor.
SELECT f.socialName
FROM seller s
INNER JOIN Supplier f ON s.socialName = f.socialName;


