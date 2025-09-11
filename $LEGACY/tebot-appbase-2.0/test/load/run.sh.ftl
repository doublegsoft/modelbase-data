
export URL = ''
export COUNT = 100
export CONCURRENCY = 10

<#list model.objects as obj>
ab -n $COUNT -c $CONCURRENCY -T 'application/json' -p test.json $URL > test.txt 
</#list>