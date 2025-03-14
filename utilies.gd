extends Node


var scale_name=['тыс','млн','млрд','трлн','квдрлн', 'квнтлн', 'скстлн','септлн','окталн','нанилн','дедалн','гугол']

func scale_numb(numb):
	var cnt=0
	var new_numb=str(numb)+scale_name[cnt]
	while abs(numb)>1000:
		cnt+=1
		new_numb=str(stepify(numb/1000,0.01))+scale_name[cnt]
		numb=stepify(numb/1000,0.01)
	return new_numb
