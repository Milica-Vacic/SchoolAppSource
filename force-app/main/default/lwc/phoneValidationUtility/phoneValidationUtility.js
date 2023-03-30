import validatePhone from '@salesforce/apex/LwcUtility.validatePhone';

let res;

const getResponse= function (phoneValue) {
    let responseText='';
    return validatePhone({ phone:phoneValue})
        .then((result)=>{
            res=JSON.parse(result);
            res.Items[0].Error ? responseText =`Error! ${res.Items[0].Description}: ${res.Items[0].Cause}` : 
                `Phone valid? ${res.Items[0].IsValid}`;
        })
        .catch((error)=>{
            res=undefined;
            responseText=`Error: ${error.body.message}`;
        })
        .then(()=>{
            return responseText
        });
}

const getDetailData =()=>{
    let details;
    if (res) details=res.Items;
    return details;
}

const getDetailColumns =()=>{
    let columns;
    if (res){
        columns=[];
        for(let fname in res.Items[0]){
            columns.push({label:fname, fieldName:fname, type:'text', wrapText:true})
        }
    }
    return columns
}

export { getDetailData, getDetailColumns, getResponse };