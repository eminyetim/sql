
declare @tcKimNo varchar(11) 
set @tcKimNo = 47503003732

declare @departmani int
SELECT  @departmani = DepartmanKodu FROM  personel_departman_view WHERE TcNo =  @tcKimNo

declare @BESYIL int
select  @BESYIL = BESYIL from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

declare @ONBESYIL int
select  @ONBESYIL = ONBESYIL from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

declare @ONBESYILDANFAZLA int
select  @ONBESYILDANFAZLA = ONBESYILDANFAZLA from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

declare @ONSEKIZYASINDANAZ int
select  @ONSEKIZYASINDANAZ = ONSEKIZYASINDANAZ from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

declare @ELLIYASINDANFAZLA int
select  @ELLIYASINDANFAZLA = ELLIYASINDANFAZLA from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

declare @IDARIIZINSAYISI int
select  @IDARIIZINSAYISI = IDARIIZINSAYISI from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

declare @HAFTATATILGUNSAYISI int
select  @HAFTATATILGUNSAYISI  = HAFTATATILGUNSAYISI from personel_izin_ayarlar_departman_view where DepartmanKodu = @departmani

select @BESYIL as besyil , @ONBESYIL as onbesyil , @ONBESYILDANFAZLA as onbesyildanfazla , 
@ONSEKIZYASINDANAZ as onsekizyasýndanaz , @ELLIYASINDANFAZLA as elliyasindafazla , @IDARIIZINSAYISI AS idariizinlisayi,
@HAFTATATILGUNSAYISI as haftalikgunsayisi


declare @yas int
declare @calyil int
declare @calyil1 int
declare @calyil2 int
declare @calyil3 int
set @calyil3 =0 
declare @calismasuresi int
declare @izingun int

select    @yas = DATEDIFF(year, DoðumTarihi,GETDATE())  from personel_izin_view 
where TcNo = @tcKimNo

select    @calismasuresi = DATEDIFF(year, IþeBaþlamaTarihi ,GETDATE())    from personel_izin_view 
where TcNo = @tcKimNo

IF @yas >= 18 AND @yas < 50 
	BEGIN

		  if(@calismasuresi >= 1 and @calismasuresi < 6)
		  BEGIN
			 set @izingun = 0
			 set @izingun = @calismasuresi * @BESYIL;
		  END
		  if(@calismasuresi >= 6 and @calismasuresi < 15)
		  BEGIN
				set @izingun = 0;
				set @calyil1 = @calismasuresi - 5
				set @calyil = @calismasuresi * @BESYIL	
				set @izingun = (5 * @BESYIL) + @ONBESYIL * @calyil1; 
		  END
		  if(@calismasuresi >= 15)
		  BEGIN
			set @izingun = 0
			set @calyil2 = @calismasuresi - 15;
			set @izingun =  (5 * @BESYIL) + (@ONBESYIL * 10 ) + (@calyil2 * @ONBESYILDANFAZLA);
		  END
	END

ELSE if (@yas < 18)
	BEGIN
		set @izingun = 0
		set @izingun = @izingun +  @ONSEKIZYASINDANAZ * @calyil3
	END

ELSE IF (@yas >= 50 )
	BEGIN
		declare @yasfarki int
		set @yasfarki = @yas - 50;

		if(@calismasuresi >= 1 and @calismasuresi < 6)
			BEGIN
				set @izingun = 0;;
				declare @kýdemfarki int
				set @kýdemfarki = @calismasuresi -  @yasfarki
				if(@kýdemfarki > 6)
					BEGIN
						if(@kýdemfarki < 6)
							BEGIN
								set @izingun = @kýdemfarki * @BESYIL + @ELLIYASINDANFAZLA * @yasfarki + @ONBESYIL + @calyil1
							END
						if(@kýdemfarki >= 6 and @kýdemfarki < 15)
							BEGIN
								SET @calyil1 = @kýdemfarki - 5;
								SET @izingun = @kýdemfarki * @BESYIL + @ELLIYASINDANFAZLA * @yasfarki + (@ONBESYIL * @calyil1)							
							END
						if(@kýdemfarki > 15)
						 BEGIN
							SET @calyil2 = @kýdemfarki - 15
							SET @izingun = @kýdemfarki* @BESYIL + @ELLIYASINDANFAZLA * @yasfarki + (@ONBESYIL * 10) + (@calyil2 + @ONBESYILDANFAZLA);
						 END
					END
					ELSE
					BEGIN
						SET @izingun = @ELLIYASINDANFAZLA * @yasfarki
					END	
				END
				   	-- 288
END

PRINT @izingun


