/* cleaning data in sql queries*/


select *
from NHdata.dbo.Nhousingdata


--standardize date format


select SaleDateConverted,CONVERT(date,saledate)
from NHdata.dbo.Nhousingdata

update NHousingData
set SaleDate=CONVERT(date,SaleDate)


alter table Nhousingdata
add SaleDateConverted date;

update NHousingData
set SaleDateConverted=CONVERT(date,SaleDate)


--populate property address data


select *
from NHdata.dbo.Nhousingdata
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,isnull(a.propertyaddress,b.PropertyAddress)
from NHdata.dbo.Nhousingdata a
join NHdata.dbo.Nhousingdata b
    on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set propertyaddress=isnull(a.PropertyAddress,b.propertyaddress)
from NHdata.dbo.Nhousingdata a
join NHdata.dbo.Nhousingdata b
    on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--breaking out address into individual columns(address,city ,state)

select PropertyAddress
from NHdata.dbo.Nhousingdata
--where PropertyAddress is null
--order by ParcelID

select
substring(PropertyAddress,1,charindex(',',PropertyAddress) -1 ) as Address
,substring(PropertyAddress,charindex(',',PropertyAddress) +1 ,LEN(PropertyAddress)) as Address
from NHdata.dbo.NHousingData


alter table Nhousingdata
add propertySplitAddress nvarchar(255);

update NHousingData
set propertySplitAddress=substring(PropertyAddress,1,charindex(',',PropertyAddress) -1 ) 


alter table NHousingData
add propertySplitCity nvarchar(255);

update NHousingData
set propertySplitCity=substring(PropertyAddress,charindex(',',PropertyAddress) +1 ,LEN(PropertyAddress))

select *
from NHdata.dbo.NHousingData


select OwnerAddress
from NHdata.dbo.NHousingData


select
PARSENAME(replace(OwnerAddress,',','.'),3)
,PARSENAME(replace(OwnerAddress,',','.'),2)
,PARSENAME(replace(OwnerAddress,',','.'),1)
from NHdata.dbo.NHousingData


alter table Nhousingdata
add OwnerSplitAddress nvarchar(255);

update NHousingData
set OwnerSplitAddress=PARSENAME(replace(OwnerAddress,',','.'),3)

alter table Nhousingdata
add OwnerSplitCity nvarchar(255);

update NHousingData
set OwnerSplitCity=PARSENAME(replace(OwnerAddress,',','.'),2)


alter table Nhousingdata
add OwnerSplitState nvarchar(255);

update NHousingData
set OwnerSplitState=PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from NHdata.dbo.NHousingData

--chang Y and N to Yes and No in 'Sold as Vacant' field

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from NHdata.dbo.NHousingData
group by SoldAsVacant
order by 2

select Soldasvacant
,case when soldasvacant = 'Y' then 'Yes'
      when soldasvacant = 'N' then 'No'
      else soldasvacant
      end
from NHousingData

update NHousingData
set  SoldAsVacant = case when soldasvacant = 'Y' then 'Yes'
      when soldasvacant = 'N' then 'No'
      else soldasvacant
      end


--remove Duplicates
with RowNumCTE as(
select *,
   ROW_NUMBER() over (
   partition by ParcelID,
                Propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by 
				  uniqueID
				  ) row_num
from NHousingData
--order by ParcelID
)
select *
from RowNumCTE
where row_num>1
--order by PropertyAddress

/*chenge 'select' to 'delete' ,it will delete duplicate data*/




select *
from NHousingData





--Delete Unused Columns


select *
from NHousingData

alter table NHousingData
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate


------------------
------------------





