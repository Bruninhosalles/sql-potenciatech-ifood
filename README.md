**Desafio SQL do Potência Tech powered by iFood**

Foi proposto para o desafio, a modelagem de projeto um de banco de dados Conceitual e Lógico para o cenário de e-commerce, a qual foi alimentado com dados fictícios para a execução de algumas querys.

    -- criação do banco de dados para o cenário de E-commerce
    create database ecommerce;
    use ecommerce;
    
    -- criar tabela cliente
    create table clients(
    		idClient int auto_increment primary key,
            Fname varchar(30) not null,
            Minit char(3),
            Lname varchar(30) not null,
            CPF char(11),
            CNPJ char(14),
            ClientType enum("PF", "PJ") not null,
            Address varchar(30),
            constraint unique_cpf_client unique (CPF),
    		constraint unique_cnpj_client unique (CNPJ)
    );
    -- criar tabela produto
    create table product(
    	idProduct int auto_increment primary key,
        Pname varchar(30) not null,
        classfication_kids bool,
        category enum('eletrônico', 'vestuário', 'brinquedos', 'Alimentos') not null,
        rating float default 0,
        size varchar(10)
    );
    -- criar tabela pagamento
    create table payments(
    	idPayment int,
        idClient int,
        typePayment enum("Pix", "Cartão de Crédito", "Cartão de Débito", "Boleto", "Transferência Bancária"),
        limitAvaliable float,
        primary key (idPayment, idClient)
    );
    
    -- criar tabela pedido
    create table request(
    	idRequest int auto_increment primary key,
        idClient int,
        status enum('Processando', 'cancelado', 'confirmado') default 'Processando',
        description varchar(255),
        freightage float default 10,
        paymentCash bool default false,
        idPayment int,
        constraint fk_request_client foreign key(idClient) references clients(idClient)
    );
    -- criar relacionamento N:M pedido/pagemento
    CREATE TABLE request_payments (
      idRequest INT NOT NULL,
      idPayment INT NOT NULL,
      idClient INT NOT NULL,
      PRIMARY KEY (idRequest, idPayment, idClient),
      CONSTRAINT fk_request_payments FOREIGN KEY(idRequest) REFERENCES request(idRequest),
      CONSTRAINT fk_request_payments_payment FOREIGN KEY(idPayment , idClient) REFERENCES payments (idPayment, idClient)
    );
    
    -- criar tabela estoque
    create table productStorage(
    	idProductStarage int primary key,
        location varchar(255),
        quantity int default 0
    );
    
    -- criar tabela fornecedor
    create table Supplier(
    	idSupplier int primary key,
        CNPJ char(15) not null,
        socialName varchar(255) not null,
        contact char(11) not null,
        constraint unique_supplier unique(CNPJ)
    );
    -- criar tabela vendedor
    create table seller(
    	idSeller int primary key,
        CNPJ char(15),
        CPF char(9),
        socialName varchar(255) not null,
        AbsName varchar(255),
        contact char(11) not null,
        Adress varchar(255),
        constraint unique_CPF_seller unique(CPF),
        constraint unique_CNPJ_seller unique(CNPJ)
    );
    
    -- criar relacionamento produto_vendedor
    create table product_seller(
    	idproduct int,
        idSeller int,
        quantity int default 1,
        primary key(idProduct, idSeller),
        constraint fk_product_seller foreign key(idSeller) references seller(idSeller),
        constraint fk_product_product foreign key(idProduct) references product(idProduct)
    );
    
    -- criar tabela de relacionamento produto_pedido
    create table product_request(
    	idProduct int,
        idRequest int,
        quantity int,
        status enum('Processando', 'cancelado', 'confirmado') default 'Processando',
        primary key(idProduct, idRequest),
        constraint fk_product_request foreign key(idProduct) references product(idProduct),
        constraint fk_request_product foreign key(idRequest) references request(idRequest)
    );
    
    -- criar tabela estoque
    create table storage_location(
    	idProduct int,
        idStorage int,
        location varchar(255) not null,
        primary key (idProduct, idStorage),
        constraint fk_storage_location_product foreign key(idProduct) references product(idProduct),
        constraint fk_storage_product foreign key(idStorage) references productStorage(idProductStarage)
    );
    
    
    -- criar tabela de relacionameto produto/fornecedor
    create table productSupplier(
    	idSupplier int,
        idProduct int,
        quantity int not null,
        primary key (idSupplier, idProduct),
        constraint fk_supplier_supplier foreign key(idSupplier) references Supplier(idSupplier),
        constraint fk_product_supplier foreign key(idProduct) references product(idProduct)
    );

Populando as tabelas:

    use ecommerce;
    -- Populando tabela clients
    INSERT INTO clients (Fname, Minit, Lname, CPF, CNPJ, ClientType, Address) VALUES
        ('Breno', 'A', 'Mendes', '12345678904', NULL, 'PF', 'Rua A, 123'),
        ('Maria', 'B', 'Santos', '98765432109', NULL, 'PF', 'Av. B, 456'),
        ('Empresa XBE', NULL, 'Indústria Ltda', NULL, '12345678901236', 'PJ', 'Rua Comercial, 789'),
        ('Empresa XYZ', NULL, 'Comércio S.A.', NULL, '98765432109866', 'PJ', 'Av. Tecnológica, 1010'),
        ('Pedro', 'CD', 'Oliveira', '45678912306', NULL, 'PF','Rua C, 789'),
        ('Mario', 'D', 'Ferreira', '65432198706', NULL, 'PF','Av. D, 456'),
        ('Empresa RE', NULL, 'Tecnologia S.A.', NULL, '34567891234564', 'PJ','Rua Industrial, 789'),
        ('Empresa TU', NULL, 'Distribuidora Ltda.', NULL, '54321678909878', 'PJ','Av. dos Distribuidores, 1010'),
        ('Lucas', 'E', 'Rocha', '78912345604', NULL, 'PF', 'Rua E, 123'),
        ('Bia', 'F', 'Pereira', '87654321905', NULL, 'PF', 'Av. F, 456'),
        ('Empresa BB', NULL, 'Eletrônicos S.A.', NULL, '76543219876543', 'PJ', 'Rua dos Eletrônicos, 789'),
        ('Empresa RET', NULL, 'Brinquedos Ltda.', NULL, '98765432123456', 'PJ', 'Av. dos Brinquedos, 1010'),
        ('Carlos', 'AD', 'Souza', '67891234501', NULL, 'PF','Rua G, 123'),
        ('Eduarda', 'RR', 'Melo', '54321987601', NULL, 'PF','Av. H, 456'),
        ('Empresa NND', NULL, 'Alimentos S.A.', NULL, '87654321987654', 'PJ','Rua das Roupas, 789');
    
    
    -- Populando tabela product
    INSERT INTO product (Pname, classfication_kids, category, rating, size) VALUES
        ('Smartphone XYZ', false, 'eletrônico', 4.5, 'Grande'),
        ('Camiseta Listrada', true, 'vestuário', 3.8, 'M'),
        ('Bola de Futebol', true, 'brinquedos', 4.2, NULL),
        ('Biscoitos de Chocolate', false, 'Alimentos', 4.0, NULL),
        ('Tablet ABC', false, 'eletrônico', 3.7, 'Médio'),
        ('Vestido Floral', true, 'vestuário', 4.1, 'P'),
        ('Carrinho de Controle Remoto', true, 'brinquedos', 4.5, NULL),
        ('Barras de Cereal', false, 'Alimentos', 3.5, NULL),
        ('Smartwatch XYZ', false, 'eletrônico', 4.3, NULL),
        ('Blusa de Moletom', true, 'vestuário', 3.9, 'G'),
        ('Quebra-Cabeça 1000 peças', true, 'brinquedos', 4.0, NULL),
        ('Biscoitos de Aveia', false, 'Alimentos', 4.2, NULL),
        ('Notebook ABC', false, 'eletrônico', 4.1, NULL),
        ('Calça Jeans', true, 'vestuário', 4.4, 'M'),
        ('Boneca de Pelúcia', true, 'brinquedos', 3.8, NULL);
    
    -- Populando tabela payments
    INSERT INTO payments (idPayment, idClient, typePayment, limitAvaliable) VALUES
        (1, 1, 'Pix', 1000.00),
        (2, 1, 'Cartão de Crédito', 2000.00),
        (3, 2, 'Transferência Bancária', 1500.00),
        (4, 3, 'Pix', 5000.00),
        (5, 4, 'Boleto', 3000.00),
        (6, 5, 'Cartão de Débito', 2500.00),
        (7, 5, 'Boleto', 3500.00),
        (8, 6, 'Pix', 2000.00),
        (9, 7, 'Pix', 4000.00),
        (10, 8, 'Boleto', 1500.00),
        (11, 9, 'Boleto', 2200.00),
        (12, 9, 'Cartão de Crédito', 1800.00),
        (13, 10, 'Pix', 2700.00),
        (14, 11, 'Pix', 3200.00),
        (15, 12, 'Boleto', 1800.00);
    
    -- Populando tabela request
    INSERT INTO request (idClient, status, description, freightage, paymentCash, idPayment) VALUES
        (1, 'confirmado', 'Pedido de smartphone', 15.50, false, 2),
        (1, 'Processando', 'Pedido de camiseta', 12.00, true, 1),
        (2, 'cancelado', 'Pedido de bola', 8.00, false, 3),
        (3, 'confirmado', 'Pedido de biscoitos', 20.00, true, 4),
        (4, 'confirmado', 'Pedido de tablet', 18.50, false, 5),
        (4, 'cancelado', 'Pedido de vestido', 10.00, false, 6),
        (5, 'Processando', 'Pedido de carrinho', 15.00, true, 7),
        (5, 'confirmado', 'Pedido de barras de cereal', 22.00, true, 8),
        (6, 'Processando', 'Pedido de smartwatch', 9.50, false, 9),
        (6, 'confirmado', 'Pedido de blusa de moletom', 14.00, true, 10),
        (7, 'Processando', 'Pedido de quebra-cabeça', 12.00, false, 11),
        (8, 'Processando', 'Pedido de biscoitos de aveia', 20.50, true, 12),
        (9, 'confirmado', 'Pedido de notebook', 16.00, false, 13),
        (9, 'cancelado', 'Pedido de calça jeans', 11.00, false, 14),
        (10, 'Processando', 'Pedido de boneca de pelúcia', 13.00, true, 15);
    
    -- Populando tabela request_payments (relacionamento N:M pedido/pagamento)
    INSERT INTO request_payments (idRequest, idPayment, idClient) VALUES
        (1, 2, 1),
        (2, 1, 1),
        (3, 3, 2),
        (4, 4, 3),
        (4, 5, 4),
        (5, 6, 5),
        (6, 7, 5),
        (7, 8, 6),
        (8, 9, 7),
        (9, 10, 8),
        (10, 11, 9),
        (11, 12, 9),
        (12, 13, 10),
        (13, 14, 11),
        (14, 15, 12);
    
    -- Populando tabela productStorage
    INSERT INTO productStorage (idProductStarage, location, quantity) VALUES
        (1, 'Prateleira A', 50),
        (2, 'Estoque B', 100),
        (3, 'Caixa 1', 25),
        (4, 'Estoque C', 500),
        (5, 'Prateleira X', 150),
        (6, 'Estoque Y', 75),
        (7, 'Caixa 2', 60),
        (8, 'Estoque Z', 300),
        (9, 'Prateleira B', 80),
        (10, 'Estoque D', 120),
        (11, 'Caixa 3', 40),
        (12, 'Estoque E', 250),
        (13, 'Prateleira C', 45),
        (14, 'Estoque F', 80),
        (15, 'Caixa 4', 30);
    
    -- Populando tabela Supplier
    INSERT INTO Supplier (idSupplier, CNPJ, socialName, contact) VALUES
        (1, '12345678901234', 'Fornecedor Eletrônicos Ltda', '987654321'),
        (2, '98765432109876', 'Fornecedor Brinquedos S.A.', '123456789'),
        (3, '87654321098765', 'Fornecedor Alimentos S.A.', '543216789'),
        (4, '56789012345678', 'Fornecedor Vestuário Ltda', '678901234'),
        (5, '34567890123456', 'Fornecedor Tecnologia Ltda', '890123456');
    
    -- Populando tabela seller
    INSERT INTO seller (idSeller, CNPJ, CPF, socialName, AbsName, contact, Adress) VALUES
        (1, NULL, '123456789', 'Vendedor A', 'Vendedor Absoluto', '987654321', 'Rua dos Vendedores, 123'),
        (2, '98765432109876', NULL, 'Empresa XYZ', 'Vendedor B', '123456789', 'Av. da Empresa, 456'),
        (3, NULL, '543216789', 'Vendedor C', 'Vendedor Sênior', '678901234', 'Rua dos Sêniores, 789'),
        (4, '34567890123457', NULL, 'Empresa QWE', 'Vendedor D', '890123456', 'Av. da Empresa, 1010'),
        (5, NULL, '678901234', 'Vendedor E', 'Vendedor Master', '901234567', 'Rua dos Mestres, 123'),
        (6, '56789012345678', NULL, 'Empresa RST', 'Vendedor F', '890123456', 'Av. da Empresa, 456'),
        (7, NULL, '890123456', 'Vendedor G', 'Vendedor Júnior', '901234567', 'Rua dos Júniores, 789'),
        (8, '45678901234567', NULL, 'Empresa ASDF', 'Vendedor H', '890123456', 'Av. da Empresa, 1010'),
        (9, NULL, '901234567', 'Vendedor I', 'Vendedor Pleno', '901234567', 'Rua dos Plenos, 123'),
        (10, '34567890123456', NULL, 'Empresa ZXCV', 'Vendedor J', '890123456', 'Av. da Empresa, 456'),
        (11, NULL, '234567890', 'Vendedor K', 'Vendedor Sênior', '901234567', 'Rua dos Sêniores, 789'),
        (12, '56789012345670', NULL, 'Empresa POIU', 'Vendedor L', '890123456', 'Av. da Empresa, 1010'),
        (13, NULL, '123456780', 'Vendedor M', 'Vendedor Master', '901234567', 'Rua dos Mestres, 123'),
        (14, '67890123456789', NULL, 'Empresa MNBV', 'Vendedor N', '890123456', 'Av. da Empresa, 456'),
        (15, NULL, '456789012', 'Vendedor O', 'Vendedor Absoluto', '901234567', 'Rua dos Vendedores, 789');
    
    -- Populando tabela product_seller (relacionamento produto/vendedor)
    INSERT INTO product_seller (idproduct, idSeller, quantity) VALUES
        (1, 1, 20),
        (2, 1, 30),
        (3, 1, 15),
        (3, 2, 100),
        (4, 2, 200),
        (5, 3, 50),
        (6, 3, 70),
        (6, 4, 30),
        (7, 4, 80),
        (8, 5, 40),
        (9, 5, 60),
        (10, 6, 25),
        (11, 6, 35),
        (11, 7, 65),
        (12, 7, 90);
    
    -- Populando tabela product_request (relacionamento produto/pedido)
    INSERT INTO product_request (idProduct, idRequest, quantity, status) VALUES
        (1, 1, 2, 'confirmado'),
        (2, 1, 1, 'cancelado'),
        (3, 2, 3, 'Processando'),
        (4, 3, 5, 'confirmado'),
        (1, 4, 1, 'confirmado'),
        (2, 4, 2, 'confirmado'),
        (4, 4, 3, 'confirmado'),
        (5, 5, 2, 'Processando'),
        (6, 5, 1, 'confirmado'),
        (7, 6, 3, 'Processando'),
        (8, 6, 1, 'confirmado'),
        (9, 7, 2, 'Processando'),
        (10, 8, 4, 'confirmado'),
        (11, 9, 1, 'confirmado'),
        (12, 10, 2, 'Processando');
    
    -- Populando tabela storage_location
    INSERT INTO storage_location (idProduct, idStorage, location) VALUES
        (1, 1, 'Prateleira A'),
        (2, 2, 'Estoque B'),
        (3, 3, 'Caixa 1'),
        (4, 4, 'Estoque C'),
        (5, 5, 'Prateleira X'),
        (6, 6, 'Estoque Y'),
        (7, 7, 'Caixa 2'),
        (8, 8, 'Estoque Z'),
        (9, 9, 'Prateleira B'),
        (10, 10, 'Estoque D'),
        (11, 11, 'Caixa 3'),
        (12, 12, 'Estoque E'),
        (13, 13, 'Prateleira C'),
        (14, 14, 'Estoque F'),
        (15, 15, 'Caixa 4');
    
    -- Populando tabela productSupplier (relacionamento produto/fornecedor)
    INSERT INTO productSupplier (idSupplier, idProduct, quantity) VALUES
        (1, 1, 100),
        (1, 2, 50),
        (2, 3, 200),
        (2, 4, 500),
        (3, 5, 150),
        (3, 6, 75),
        (4, 7, 60),
        (4, 8, 300),
        (5, 9, 80),
        (5, 10, 120),
        (1, 11, 40),
        (2, 12, 250),
        (3, 13, 45),
        (4, 14, 80),
        (5, 15, 30);

Consultas e Querys:

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



