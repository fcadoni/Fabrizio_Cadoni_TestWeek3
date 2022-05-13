use master
go
create database Pizzeria_Da_Luigi
go
use Pizzeria_Da_Luigi

create table Pizze
(
	codicePizza int primary key identity(1,1),
	nome nvarchar(30) not null,
	prezzo decimal(10,2),
	constraint CHK_PREZZO_PIZZA	check (prezzo > 0)
)

create table Ingredienti
(
	codiceIngrediente int primary key identity(1,1),
	nome nvarchar(30) not null,
	costo decimal(10,2),
	scorte int,
	constraint CHK_PREZZO_INGREDIENTE check (costo > 0),
	constraint CHK_SCORTE_INGREDIENTE check (scorte >= 0)
)

create table IngredientiPizze
(
	codicePizza int foreign key references Pizze(codicePizza),
	codiceIngrediente int foreign key references Ingredienti(codiceIngrediente),
	constraint PK_INGREDIENTI_PIZZE primary key (codicePizza, codiceIngrediente)
)


insert into Ingredienti values ('pomodoro', 0.4, 100)
insert into Ingredienti values ('mozzarella', 1, 200)
insert into Ingredienti values ('mozzarella di bufala', 1.8, 60)
insert into Ingredienti values ('spianata piccante', 1.5, 70)
insert into Ingredienti values ('funghi', 1.3, 100)
insert into Ingredienti values ('carciofi', 1.6, 120)
insert into Ingredienti values ('cotto', 1.35, 90)
insert into Ingredienti values ('olive', 0.2, 150)
insert into Ingredienti values ('stracchino', 1, 40)
insert into Ingredienti values ('speck', 1.15, 50)
insert into Ingredienti values ('rucola', 0.4, 85)
insert into Ingredienti values ('grana', 1, 115)
insert into Ingredienti values ('verdure di stagione', 0.65, 80)
insert into Ingredienti values ('patate', 0.3, 200)
insert into Ingredienti values ('salsiccia', 1, 160)
insert into Ingredienti values ('pomodorini', 0.6, 90)
insert into Ingredienti values ('ricotta', 1.2, 40)
insert into Ingredienti values ('provola', 1, 70)
insert into Ingredienti values ('gorgonzola', 1, 70)
insert into Ingredienti values ('grana', 0.8, 90)
insert into Ingredienti values ('pomodoro fresco', 0.6, 70)
insert into Ingredienti values ('basilico', 0.1, 100)
insert into Ingredienti values ('bresaola', 1.05, 60)
insert into Ingredienti values ('funghi porcini', 1.3, 60)

-- =============== QUERIES =============== 

-- 1. Estrarre tutte le pizze con prezzo superiore a 6 euro.
select nome as [Pizze con prezzo maggiore di 6 euro], prezzo 
from Pizze 
where prezzo > 6

-- 2. Estrarre la pizza/le pizze più costosa/e.
select nome as [Pizza più costosa], prezzo
from Pizze 
where prezzo = (select MAX(prezzo) from Pizze)

-- 3. Estrarre le pizze «bianche»
select nome, prezzo
from Pizze
where nome not in 
	(select p.nome
	from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
					join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
	where i.nome = 'pomodoro')

-- 4. Estrarre le pizze che contengono funghi (di qualsiasi tipo).
select *
from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
				join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
where i.nome like 'funghi%'

select * from Pizze
select * from Ingredienti
select * from IngredientiPizze

-- =============== PROCEDURE =============== 

-- 1. Inserimento di una nuova pizza (parametri: nome, prezzo) 
create procedure InserisciPizza
@nome nvarchar(30),
@prezzo decimal(10,2)
as
insert into Pizze values (@nome, @prezzo)

execute InserisciPizza 'Margherita', 5
execute InserisciPizza 'Bufala', 7
execute InserisciPizza 'Diavola', 6
execute InserisciPizza 'Quattro stagioni', 6.5
execute InserisciPizza 'Porcini', 7
execute InserisciPizza 'Dioniso', 8
execute InserisciPizza 'Ortolana', 8
execute InserisciPizza 'Patate e salsiccia', 6
execute InserisciPizza 'Pomodorini', 6
execute InserisciPizza 'Quattro formaggi', 7.5
execute InserisciPizza 'Caprese', 7.5
execute InserisciPizza 'Zeus', 7.5




-- 2. Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome ingrediente) 
create procedure AssegnaIngredienti
@nomePizza nvarchar(30),
@nomeIngrediente nvarchar(30)
as
declare @codicePizza int
declare @codiceIngrediente int

select @codicePizza = p.codicePizza 
from Pizze p 
where p.nome = @nomePizza

select @codiceIngrediente = i.codiceIngrediente
from Ingredienti i 
where i.nome = @nomeIngrediente

insert into IngredientiPizze values (@codicePizza, @codiceIngrediente)


exec AssegnaIngredienti 'margherita', 'pomodoro'
exec AssegnaIngredienti 'margherita', 'mozzarella'

exec AssegnaIngredienti 'bufala', 'pomodoro'
exec AssegnaIngredienti 'bufala', 'mozzarella di bufala'

exec AssegnaIngredienti 'diavola', 'pomodoro'
exec AssegnaIngredienti 'diavola', 'mozzarella'
exec AssegnaIngredienti 'diavola', 'spianata piccante'

exec AssegnaIngredienti 'quattro stagioni', 'pomodoro'
exec AssegnaIngredienti 'quattro stagioni', 'mozzarella'
exec AssegnaIngredienti 'quattro stagioni', 'funghi'
exec AssegnaIngredienti 'quattro stagioni', 'carciofi'
exec AssegnaIngredienti 'quattro stagioni', 'cotto'
exec AssegnaIngredienti 'quattro stagioni', 'olive'

exec AssegnaIngredienti 'porcini', 'pomodoro'
exec AssegnaIngredienti 'porcini', 'mozzarella'
exec AssegnaIngredienti 'porcini', 'funghi porcini'

exec AssegnaIngredienti 'dioniso', 'pomodoro'
exec AssegnaIngredienti 'dioniso', 'mozzarella'
exec AssegnaIngredienti 'dioniso', 'stracchino'
exec AssegnaIngredienti 'dioniso', 'speck'
exec AssegnaIngredienti 'dioniso', 'rucola'
exec AssegnaIngredienti 'dioniso', 'grana'

exec AssegnaIngredienti 'ortolana', 'pomodoro'
exec AssegnaIngredienti 'ortolana', 'mozzarella'
exec AssegnaIngredienti 'ortolana', 'verdure di stagione'

exec AssegnaIngredienti 'patate e salsiccia', 'mozzarella'
exec AssegnaIngredienti 'patate e salsiccia', 'patate'
exec AssegnaIngredienti 'patate e salsiccia', 'salsiccia'


exec AssegnaIngredienti 'pomodorini', 'mozzarella'
exec AssegnaIngredienti 'pomodorini', 'pomodorini'
exec AssegnaIngredienti 'pomodorini', 'ricotta'


exec AssegnaIngredienti 'quattro formaggi', 'mozzarella'
exec AssegnaIngredienti 'quattro formaggi', 'provola'
exec AssegnaIngredienti 'quattro formaggi', 'gorgonzola'
exec AssegnaIngredienti 'quattro formaggi', 'grana'


exec AssegnaIngredienti 'caprese', 'mozzarella'
exec AssegnaIngredienti 'caprese', 'pomodoro fresco'
exec AssegnaIngredienti 'caprese', 'basilico'


exec AssegnaIngredienti 'zeus', 'mozzarella'
exec AssegnaIngredienti 'zeus', 'bresaola'
exec AssegnaIngredienti 'zeus', 'rucola'
exec AssegnaIngredienti 'zeus', 'patate'






-- 3. Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)
create procedure AggiornaPrezzoPizza
@nomePizza nvarchar(30),
@nuovoPrezzo decimal(10,2)
as
update Pizze 
set prezzo = @nuovoPrezzo
where nome = @nomePizza
go

exec AggiornaPrezzoPizza 'porcini', 7


-- 4. Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome ingrediente)
create procedure RimuoviIngrediente
@nomePizza nvarchar(30),
@nomeIngrediente nvarchar(30)
as
declare @codicePizza int
declare @codiceIngrediente int

select @codicePizza = p.codicePizza 
from Pizze p 
where p.nome = @nomePizza

select @codiceIngrediente = i.codiceIngrediente
from Ingredienti i 
where i.nome = @nomeIngrediente

delete 
from IngredientiPizze 
where codicePizza = @codicePizza 
and codiceIngrediente = @codiceIngrediente
go

exec RimuoviIngrediente 'zeus', 'patate'

-- 5. Incremento del 10% del prezzo delle pizze contenenti un ingrediente (parametro: nome ingrediente)		
create procedure IncrementaPrezzo
@nomeIngrediente varchar(30)
as
declare @codicePizza int
select @codicePizza = p.codicePizza 
from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
				join Ingredienti i on i.codiceIngrediente = ip.codiceIngrediente
where i.nome = @nomeIngrediente
update Pizze 
set prezzo = prezzo * 1.1
where codicePizza = @codicePizza 
go


exec IncrementaPrezzo 'funghi porcini'




select * from Pizze
select * from Ingredienti
select * from IngredientiPizze

-- =============== FUNZIONI =============== 

-- 1. Tabella listino pizze (nome, prezzo) (parametri: nessuno)
create function ListinoPizze()
returns table
as
return
select nome as Pizze, prezzo as Prezzo
from Pizze

select * from ListinoPizze()

-- 2. Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome ingrediente)
create function ListinoPizzeIngrediente(@nomeIngrediente nvarchar(30))
returns table
as
return
select nome as Pizze, prezzo as Prezzo
from Pizze	
where nome in 
	(select p.nome 
	from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
					join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
	where i.nome = @nomeIngrediente)

select * from ListinoPizzeIngrediente('pomodoro')

-- 3. Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente (parametri: nome ingrediente)
create function ListinoPizzeSenzaIngrediente(@nomeIngrediente nvarchar(30))
returns table
as
return
select nome as Pizze, prezzo as Prezzo
from Pizze	
where nome not in 
	(select p.nome 
	from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
					join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
	where i.nome = @nomeIngrediente)

select * from ListinoPizzeSenzaIngrediente('pomodoro')

-- 4. Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
create function NumPizzeIngrediente(@nomeIngrediente nvarchar(30))
returns int
as
begin
declare @numPizze int

select @numPizze = COUNT(*)
from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
				join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
where i.nome = @nomeIngrediente
return @numPizze
end

select dbo.NumPizzeIngrediente('pomodoro') as [Numero di pizze]

-- 5. Calcolo numero pizze che non contengono un ingrediente (parametri: codice ingrediente)
create function NumPizzeSenzaIngrediente(@nomeIngrediente nvarchar(30))
returns int
as
begin
declare @numPizze int

select @numPizze = COUNT(*)
from Pizze
where nome not in 
	(select p.nome
	from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
					join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
	where i.nome = @nomeIngrediente)
return @numPizze
end

select dbo.NumPizzeSenzaIngrediente('pomodoro') as [Numero di pizze]

-- 6. Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
create function NumIngredienti(@nomePizza nvarchar(30))
returns int
as
begin
declare @numIngredienti int
select @numIngredienti = COUNT(*)
from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
				join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
group by p.nome
having p.nome = @nomePizza
return @numIngredienti
end

select dbo.NumIngredienti('dioniso') as [Numero di ingredienti]


--  =============== VISTA  =============== 


-- Creo una funzione d'appoggio per calcolare la stringa degli ingredienti
create function ElaboraStringaIngredienti(@nomePizza nvarchar(30))
returns nvarchar(100)
as
begin
declare @stringaIngredienti nvarchar(100)
select @stringaIngredienti = SUBSTRING(
        (select ', ' + i.nome 
        from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
						join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
		where p.nome = @nomePizza 
        for xml path ('')
        )
    , 3, 100)
return @stringaIngredienti
end

-- Creo la vista
create view VistaMenu
as  
select distinct p.nome as Pizza, p.prezzo as Prezzo, dbo.ElaboraStringaIngredienti(p.nome) as Ingredienti
from Pizze p	join IngredientiPizze ip on p.codicePizza = ip.codicePizza
				join Ingredienti i on ip.codiceIngrediente = i.codiceIngrediente
go  
select * from VistaMenu