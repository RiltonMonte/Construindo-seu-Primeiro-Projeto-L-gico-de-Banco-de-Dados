-- Criação do Banco de Dados para E-commerce
-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- Criar tabela Cliente
create table clients(
	idClient int auto_increment primary key,
    socialName varchar(100) not null,
    clientType enum('Pessoa Fisica', 'Pessoa Juridica') default 'Pessoa Fisica',
    Address varchar(255)
);

alter table clients auto_increment=1;

-- Criando tabela PF
create table natural_person(
	idNPclient int,
    CPF char(11) not null,
	constraint unique_cpf_client unique(CPF),
    constraint fk_naturalPerson_client foreign key (idNPclient) references clients(idClient)
);
    
-- Criando tabela PJ
create table juristic_person(
	idJPclient int,
	fantasyName varchar(100),
    CNPJ char(15) not null,
    constraint unique_cnpj_client unique (CNPJ),
    constraint fk_juristicPerson_client foreign key (idJPClient) references clients(idClient)
);

-- Criando tabela Cartão
create table Card(
	idCard int auto_increment primary key,
	idCardClient int,
	cardNumber char(16) not null,
	expiration char(4) not null,
	cardName varchar(45) not null,
	constraint unique_card_number unique (cardNumber),
	constraint fk_card_Client foreign key(idCardClient) references clients(idClient)
);

-- Criar tabela Produto
-- size = dimensão do produto
create table product(
	idProduct int auto_increment primary key,
    Pname  varchar(30) not null,
    classification_kids bool default false,
	category enum('Eletronico', 'Vestimenta', 'Brinquedos','Alimentos','Moveis') not null,
    descrição varchar(30),
    avaliação float default 0 ,
    size varchar(15),
    price float not null
);

-- Criar tabela Pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderDescription varchar(255),    
	typePayment enum('Pix','Boleto','Cartão','Dois cartões') default 'Boleto',
    orderStatus enum('Em andamento', 'Processando', 'Enviado', 'Entregue','Cancelado') default 'Processando',
    trackingCode varchar(10),
    deliveryValue float default 0,
    orderValue float default 1,
    constraint fk_orders_client foreign key (idOrderClient) references clients(idClient)
			on update cascade
);

-- Criar tabela Estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
    
);

-- Criar tabela Fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(100) not null,
    fantasyName varchar(100),
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)    
);

-- Criar tabela Vendedor
create table seller(
	idSeller int auto_increment primary key,
	socialName varchar(255) not null,
    fantasyName varchar(255),
    CNPJ char(15),
	CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_seller_PJ unique (CNPJ),  
    constraint unique_seller_PF unique (CPF)
);

-- Criar tabela de Produtos Vendidos Por Terceiros
create table productSeller(
	idProdSeller int,
    idProduct int,
    prodQuantity int default 1,
    primary key (idProdSeller, idProduct),
    constraint fk_product_seller foreign key (idProdSeller) references seller(idSeller),
    constraint fk_product_product foreign key (idProduct) references product(idProduct)
);

-- Criar tabela Produto/Pedido
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponivel', 'Sem estoque') default 'Disponivel',
    primary key (idPOproduct, idPOorder),
    constraint fk_po_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_po_order foreign key (idPOorder) references orders(idOrder)
);

-- Criar tabela Produto em Estoque
create table productLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

-- Criar tabela Fornece Produto
create table productSupplier(
	idPSproduct int,
    idPSsupplier int,
    Quantity int not null,
    primary key (idPSproduct, idPSsupplier),
    constraint fk_PS_product foreign key (idPSproduct) references product(idProduct),
    constraint fk_PS_supplier foreign key (idPSsupplier) references supplier(idSupplier)
);


-- inserção de Dados

-- tabela Cliente
-- socialName,clientType enum('Pessoa Fisica', 'Pessoa Juridica') default 'Pessoa Fisica', Address 
insert into clients(socialName, clientType, Address )
			values('Maria M Silva',default,'rua da silva de prata 29, carangola - Cidade das flores'),
				  ('Matheus O Pimentel','Pessoa Fisica','rua alameda 289, centro - Cidade das flores'),
				  ('Ricardo F Silva','Pessoa Fisica','avenida alameda vinha 1009, centro - Cidade das flores'),
                  ('Joana Alimentos','Pessoa juridica','rua C 10, mussurunga - Salvador'),
                  ('Julia S França',default,'rua laranjeiras 861, centro - Cidade das flores'),
                  ('Eletrica Naldo','Pessoa juridica','rua 40 Quadra 9 Lote 11, Centro - Eunapolis'),
                  ('Roberta G Assis','Pessoa Fisica','avenida koller 19, centro - Cidade das flores'),
                  ('Isabela M Cruz',default,'rua alameda das flores 28, centro - Cidade das flores');


-- tabela Cliente PF
-- idNPclient, CPF
insert into natural_person(idNPclient, CPF)
			values(1,'12345678901'),
				  (2,'10987654321'),
                  (3,'45678913452'),
                  (5,'78912345601'),
                  (7,'98745631963'),
                  (8,'65478912314');

-- tabela cliente PJ
-- idJPclient, fantasyName, CNPJ
insert into juristic_person(idJPclient, fantasyName, CNPJ)
			values(4,'Restaurante Casa da Mae Joana',852963741000112),
				  (6,'Nal do Canal','753869429000151');
                  
-- tabela Cartão
-- idCardClient, cardNumber, expiration, cardName
insert into Card(idCardClient, cardNumber, expiration, cardName)
				values(3,'1470258936982587','0426','Ricardo F Silva'),
					  (4,'7894561230148521','1224','Maria Joana'),
                      (6,'9867534210326159','0825','Ronaldo G Lima'),
                      (6,'1247849683624862','0327','Eletrica Naldo'),
                      (7,'9874123650159753','0123','Roberta Assis');


-- tabela Produto
insert into product (Pname, classification_kids, category, descrição, avaliação, size, price)
			values('Fone de ouvido',false,'Eletronico','Fone de ouvido',4,null,130.00),
				  ('Barbie Elsa',true,'Brinquedos','Barbie Elsa',3,null,300.00),
                  ('Body Carters',true,'Vestimenta','Body Carters',5,null,150.00),
                  ('Microfone Vedo - Youtuber',false,'Eletronico','Microfone Vedo - Youtuber',4,null,250.00),
                  ('Sofa Retratil',false,'Moveis','Sofa Retratil',3,'50x100x80',300.00),
                  ('Farinha de arroz',false,'Alimentos','Farinha de arroz',2,null,25.00),
                  ('Fire Stick Amazon',false,'Eletronico','Fire Stick Amazon',3,null,200.00);

-- tabela Pedido
-- idOrderClient, orderDescription, typePayment ('Pix','Boleto','Cartão','Dois cartões') default 'Boleto', orderStatus('Em andamento', 'Processando', 'Enviado', 'Entregue','Cancelado') default 'Processando', trackingCode , deliveryValue, orderValue
insert into orders (idOrderClient, orderDescription, typePayment, orderStatus, trackingCode , deliveryValue, orderValue)
			values(1,'compra via aplicativo','Pix',default,null,default,100),
				  (2,'compra via aplicativo',default,'Em andamento',null,default,200),
				  (2,'compra via aplicativo',default,'Enviado','123456A',50,150),
                  (3,'compra via Website','Cartão','Entregue','123456789A',120,300),
                  (4,'compra via aplicativo','Cartão','Cancelado',null,default,150),
                  (4,'compra via Website','Cartão','Cancelado','1236547B',50,150),
                  (4,'compra via Website','Cartão','Enviado','1259841A',50,150),
                  (5,'compra via aplicativo','Pix','Em andamento',null,default,350),
                  (6,'compra via Website','Dois cartões','Entregue','1254697A',100,400),
                  (7,'compra via Website','Cartão','Cancelado',null,150,100),
                  (7,'compra via aplicativo','Pix','Processando','1256487B',75,100),
                  (8,'compra via aplicativo','Boleto','Processando','1263421B',50,200);


-- tabela Produto/Pedido
-- idPOproduct,idPOorder,poQuantity,poStatus('Disponivel', 'Sem estoque')
insert into productOrder (idPOproduct,idPOorder,poQuantity,poStatus)
			values(2,1,2,default),
				  (5,2,1,'Sem estoque'),
                  (7,3,1,default),
                  (3,4,1,default),
                  (3,6,1,'Sem estoque'),
                  (6,7,10,default),
                  (1,9,1,default),
                  (4,9,1,default),
                  (7,11,1,default),
                  (1,12,1,default);

-- tabela Estoque
-- storageLocation,quantity
insert into productStorage (storageLocation,quantity)
			values('Rio de Janeiro',1000),
				  ('Rio de janeiro',500),
                  ('São Paulo', 10),
                  ('São Paulo', 100),
                  ('São Paulo', 10),
                  ('Brasilia', 60);

-- tabela Produto em Estoque
-- idLproduct, idLstorage, location
insert into productLocation(idLproduct, idLstorage, location)
			values(1,2,'RJ'),
				  (2,6,'GO');

-- tabela Fornecedor
-- socialName, fantasyName, CNPJ, contact
insert into supplier(socialName, fantasyName, CNPJ, contact)
			values('Almeida e filhos','A&F','123456789000156','21985474'),
				  ('Eletronicos Silva',null,'854519649000157','21985484'),
                  ('Eletronicos Valma','Ev Eletronicos','934567893000195','21975474');

-- tabela Fornece Produto
-- idPSproduct, idPSsupplier, Quantity
insert into productSupplier(idPSsupplier,idPSproduct, Quantity)
			values(1,1,500),
				  (1,2,400),
                  (2,4,633),
                  (3,3,5),
                  (2,5,10);

-- tabela Vendedor
-- idSeller,SocialName,fantasyName,CNPJ,CPF,location,contact
insert into seller(SocialName,fantasyName,CNPJ,CPF,location,contact)
			values('Tech eletronics',null,'123456789000121',null,'Rio de Janeiro','219946287'),
				  ('Boutique Durgas',null,null,'123456783','Rio de Janeiro','219567895'),
                  ('Kids World',null,456789123000185,null,'São Pàulo','1198657484');



-- tabela de Produtos Vendidos Por Terceiros
-- idProdSeller,idProduct,prodQuantity

insert into productSeller(idProdSeller,idProduct,prodQuantity)
			values(1,6,80),
				  (2,7,10);


-- Queries

-- Recuperando total de clientes
select count(*) from clients;

-- recuperando informações de cliente PJ
select idClient,socialName as Nome, CNPJ, Address from juristic_person, clients where idJPclient = idClient;

-- recuperando informações de cliente PF
select idClient, socialName as Nome, CPF, Address from natural_person, clients where idClient = idNPclient;

-- recuperando quantos pedidos foram feitos por cliente
select idClient as ID, socialName as Client_Name, count(*) as Number_Of_Orders from orders, clients where idOrderClient = idClient group by idClient;

-- recuperando relação de quais cliente fizeram 2 ou mais pedidos
select idClient as ID, socialName as Client_Name, count(*) as Number_Of_Orders from orders, clients 
	where idOrderClient = idClient
    group by idClient
    having count(*)>=2;

-- recuperando quantos vendedores terceirizados tambem são fornecedores
select * from Seller t, Supplier s where t.CNPJ = s.CNPJ;

-- recuperando relação entre produtos, fornecedores e estoque
select * from supplier join productSupplier on idPSsupplier = idSupplier join product on idPSproduct = idProduct;

-- recuperando relação nome dos fornecedores e nome dos produtos
select idSupplier, idProduct, socialName as Supplier, Pname as Product
	from supplier join productSupplier on idPSsupplier = idSupplier 
	join product on idPSproduct = idProduct
	order by idProduct;






