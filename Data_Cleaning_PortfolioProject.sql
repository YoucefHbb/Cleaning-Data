
/*

            Cleaning Data in SQL Queries 

*/

----------------------------------------------------------------------------------------------- 


	select *
	from Portfolio_Project..NashvilleHousing

-----------------------------------------------------------------------------------------------

	-- Standardize Date format

	select *
	from Portfolio_Project..NashvilleHousing

	-- To change the type of the SaleDate column we have these two methodes

	alter table Portfolio_Project..NashvilleHousing
	alter column SaleDate date


	update Portfolio_Project..NashvilleHousing
	set SaleDate =  convert(date , SaleDate) 

-------------------------------------------------------------------------------------------------

	-- Populate property address data 

	select *
	from Portfolio_Project..NashvilleHousing
	--where PropertyAddress is null
	order by ParcelID

	
	select a.ParcelID , a.PropertyAddress , b.ParcelID , b.PropertyAddress , ISNULL(a.PropertyAddress , b.PropertyAddress)
	from Portfolio_Project..NashvilleHousing a
	join Portfolio_Project..NashvilleHousing b
		on a.ParcelID = b.ParcelID
		where a.UniqueID <> b.UniqueID and a.PropertyAddress is null

	update    a                                    
	set PropertyAddress = ISNULL(a.PropertyAddress , b.PropertyAddress)
	from Portfolio_Project..NashvilleHousing a
	join Portfolio_Project..NashvilleHousing b
		on a.ParcelID = b.ParcelID
	where a.UniqueID <> b.UniqueID and a.PropertyAddress is null


----------------------------------------------------------------------------------------------------

	-- Breaking out address into individual columns (Address , City , State)

	select PropertyAddress , SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress) -1)
	,SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) + 1 , LEN(PropertyAddress))
	from Portfolio_Project..NashvilleHousing

	alter table Portfolio_Project..NashvilleHousing
	add	 PropertySplitAddress nvarchar(100)	

	update Portfolio_Project..NashvilleHousing
	set PropertySplitAddress = SUBSTRING(PropertyAddress , 1 , CHARINDEX(',' , PropertyAddress) -1)

	alter table Portfolio_Project..NashvilleHousing
	add	 PropertyCity nvarchar(100)	

	update Portfolio_Project..NashvilleHousing
	set PropertyCity = SUBSTRING(PropertyAddress , CHARINDEX(',' , PropertyAddress) + 1 , LEN(PropertyAddress))



	select OwnerAddress, PARSENAME(REPLACE(OwnerAddress , ',' , '.'),1)
	from Portfolio_Project..NashvilleHousing

	alter table Portfolio_Project..NashvilleHousing
	add OwnerSplitAddress nvarchar(100)

	update Portfolio_Project..NashvilleHousing
	set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress , ',' , '.'),3)

	alter table Portfolio_Project..NashvilleHousing
	add OwnerSplitCity nvarchar(100)

	update Portfolio_Project..NashvilleHousing
	set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress , ',' , '.'),2)

	alter table Portfolio_Project..NashvilleHousing
	add OwnerSplitState nvarchar(100)

	update Portfolio_Project..NashvilleHousing
	set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress , ',' , '.'),1)

	select ownersplitaddress , ownersplitcity , ownersplitstate
	from Portfolio_Project..NashvilleHousing

---------------------------------------------------------------------------------------------------

	-- Change 1 and 0 to Yes and No in "Sold as Vacant" field

	select  distinct(SoldAsVacant) , COUNT(SoldAsVacant)
	from Portfolio_Project..NashvilleHousing
	group by SoldAsVacant

	select SoldAsVacant,
	case when SoldAsVacant = 0 then 'No'
		 when SoldAsVacant = 1 then 'Yes'
	end 
	from Portfolio_Project..NashvilleHousing

	alter table Portfolio_Project..NashvilleHousing
	alter column SoldAsVacant varchar(3)

	update Portfolio_Project..NashvilleHousing
	set SoldAsVacant = case when SoldAsVacant = 0 then 'No'
							when SoldAsVacant = 1 then 'Yes'
							end 
	select *
	from Portfolio_Project..NashvilleHousing

------------------------------------------------------------------------------------------------

	-- Remove Duplicates

	select *,
	ROW_NUMBER() over (partition by ParcelID,
									PropertyAddress,
									SaleDate,
									SalePrice,
									LegalReference
									order by UniqueID
									) row_num
	from Portfolio_Project..NashvilleHousing

	with RowNum as
	(select ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference,
	ROW_NUMBER() over (partition by ParcelID,
									PropertyAddress,
									SaleDate,
									SalePrice,
									LegalReference
									order by UniqueID
									) row_num
	from Portfolio_Project..NashvilleHousing
	)

	select *
	from RowNum
	where row_num > 1


-------------------------------------------------------------------------------------------


	-- Delete unused columns

	select * 
	from Portfolio_Project..NashvilleHousing

	alter table Portfolio_Project..NashvilleHousing
	drop column OwnerAddress ,TaxDistrict , PropertyAddress




















