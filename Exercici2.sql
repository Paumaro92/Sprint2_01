-- 1.Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els/les alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
select apellido1, apellido2, nombre from persona where tipo = 'alumno' order by apellido1, apellido2, nombre;
-- 2.Esbrina el nom i els dos cognoms dels/les alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
select nombre, apellido1, apellido2 from persona where tipo = 'alumno' and (telefono is NULL);
-- 3.Retorna el llistat dels/les alumnes que van néixer en 1999.
select * from persona where tipo = 'alumno' and year (fecha_nacimiento) = '1999';
-- 4.Retorna el llistat de professors/es que no han donat d'alta el seu número de telèfon en la base de dades i a més el seu NIF acaba en K.
select * from persona where tipo = 'profesor' and (telefono is null) and nif like '%k';
-- 5.Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
select nombre, creditos, tipo from asignatura where cuatrimestre = 1 and curso = 3 and id_grado = 7;
-- 6.Retorna un llistat dels professors/es juntament amb el nom del departament al qual estan vinculats/des. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
select p.nombre, p.apellido1, p.apellido2, d.nombre as departamento from profesor pr join persona p on pr.id_profesor = p.id join departamento d on pr.id_departamento = d.id where p.tipo = 'profesor' order by p.apellido1, p.apellido2, p.nombre;
-- 7.Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne/a amb NIF 26902806M.
select a.nombre as asignatura, ce.anyo_inicio, ce.anyo_fin from asignatura a join alumno_se_matricula_asignatura m on a.id = m.id_asignatura join curso_escolar ce on m.id_curso_escolar = ce.id join persona p on m.id_alumno = p.id where p.nif = '26902806M'order by ce.anyo_inicio, a.nombre;
-- 8.Retorna un llistat amb el nom de tots els departaments que tenen professors/es que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
select distinct d.nombre from departamento d join profesor pr on d.id = pr.id_departamento join asignatura a on pr.id_profesor = a.id_profesor join grado g on a.id_grado = g.id where g.nombre = 'Grado en Ingeniería Informática (Plan 2015)';
-- 9.Retorna un llistat amb tots els/les alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
select distinct p.nombre, p.apellido1, p.apellido2 from persona p join alumno_se_matricula_asignatura a on p.id = a.id_alumno join curso_escolar c on a.id_curso_escolar = c.id where c.anyo_inicio = '2018' and c.anyo_fin = '2019' and p.tipo = 'alumno';
-- Resol les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.

-- 1.Retorna un llistat amb els noms de tots els professors/es i els departaments que tenen vinculats/des. El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor/a. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
select d.nombre as nombre_departamento, p.apellido1, p.apellido2, p.nombre from persona p left join profesor pr on p.id = pr.id_profesor left join departamento d on pr.id_departamento = d.id where p.tipo = 'profesor' order by d.nombre asc, p.apellido1 asc, p.apellido2 asc, p.nombre asc;
-- 2.Retorna un llistat amb els professors/es que no estan associats a un departament.
select p.nombre, p.apellido1, p.apellido2, d.nombre as departamento from persona p right join profesor pr on p.id = pr.id_profesor right join departamento d on pr.id_departamento = d.id where p.tipo = 'profesor' and pr.id_profesor IS NULL order by d.nombre, p.nombre, p.apellido1, p.apellido2; 
-- 3.Retorna un llistat amb els departaments que no tenen professors/es associats.
select d.nombre from departamento d left join profesor p on d.id = p.id_departamento where p.id_profesor is null;
-- 4.Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
select p.nombre, p.apellido1, p.apellido2 from persona p join profesor pr on p.id = pr.id_profesor left join asignatura a on pr.id_profesor = a.id_profesor where a.id_profesor is null and p.tipo = 'profesor'; 
-- 5.Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
select a.nombre from profesor pr right join asignatura a on pr.id_profesor = a.id_profesor where pr.id_profesor is null;
-- 6.Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
select distinct d.nombre from departamento d left join profesor p on d.id = p.id_departamento left join asignatura a on a.id_profesor = p.id_profesor left join alumno_se_matricula_asignatura ama on  a.id = ama.id_asignatura where ama.id_curso_escolar is null;
-- Consultes resum:

-- 1.Retorna el nombre total d'alumnes que hi ha.
select count(*) as total_alumnes from persona where tipo = 'alumno';
-- 2.Calcula quants/es alumnes van néixer en 1999.
select * from persona where tipo = 'alumno' and year(fecha_nacimiento) = '1999';
-- 3.Calcula quants/es professors/es hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors/es que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors/es associats i haurà d'estar ordenat de major a menor pel nombre de professors/es.
select d.nombre as nombre_departamento, count(p.id_profesor) as numero_profesores from departamento d join profesor p on d.id = p.id_departamento group by d.id, d.nombre order by numero_profesores desc, d.nombre;
-- 4.Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. Té en compte que poden existir departaments que no tenen professors/es associats/des.
select d.nombre as nombre_departamento, count( p.id_profesor) as numero_profesores from departamento d left join profesor p on d.id = p.id_departamento group by d.id, d.nombre;
-- 5.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Té en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
select g.nombre as nombre_grado, count(a.id) as numero_asignaturas from grado g left join asignatura a on g.id = a.id_grado group by g.id, g.nombre order by numero_asignaturas desc;
-- 6.Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
select g.nombre as nombre_grado, count(a.id) as numero_asignaturas from grado g left join asignatura a on g.id = a.id_grado group by g.id, g.nombre having count(a.id) > 40 order by numero_asignaturas desc;
-- 7.Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
 select g.nombre as nombre_grado, a.tipo as tipo_asignatura, sum(a.creditos) as suma_creditos from grado g join asignatura a on g.id = a.id_grado group by g.nombre, a.tipo order by suma_creditos desc;
-- 8.Retorna un llistat que mostri quants/es alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats/des.
select ce.anyo_inicio, count(distinct ama.id_alumno) as numero_alumnos from curso_escolar ce left join alumno_se_matricula_asignatura ama on ce.id = ama.id_curso_escolar group by ce.anyo_inicio, ce.id order by ce.anyo_inicio;
-- 9.Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
select pr.id_profesor, p.nombre, p.apellido1, p.apellido2, count(a.id) as numero_asignaturas from profesor pr join persona p on pr.id_profesor = p.id left join asignatura a on pr.id_profesor = a.id_profesor group by pr.id_profesor;
-- 10.Retorna totes les dades de l'alumne més jove.
select * from persona where tipo = 'alumno' and fecha_nacimiento = (select max(fecha_nacimiento) from persona where tipo = 'alumno');
-- 11.Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
select persona.* from profesor pr join persona on profesor.id_profesor = persona.id left join asignatura on profesor.id_profesor = asignatura.id_profesor where asignatura.id_profesor is null;