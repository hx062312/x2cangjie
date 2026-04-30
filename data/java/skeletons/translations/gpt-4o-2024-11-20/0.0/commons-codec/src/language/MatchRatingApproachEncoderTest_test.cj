// Package: commons_codec.language
package commons_codec.language

// Imports Begin
// Imports End

@Test
open class MatchRatingApproachEncoderTest {
    // Fields Begin
    // Fields End

    // Methods Begin
    public func testAccentRemoval_AllLower_SuccessfullyRemoved(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_WithSpaces_SuccessfullyRemovedAndSpacesInvariant(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_UpperandLower_SuccessfullyRemovedAndCaseInvariant(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_MixedWithUnusualChars_SuccessfullyRemovedAndUnusualcharactersInvariant(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_GerSpanFrenMix_SuccessfullyRemoved(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_ComprehensiveAccentMix_AllSuccessfullyRemoved(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemovalNormalString_NoChange(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_NINO_NoChange(): Unit {
        throw Exception('TODO')
    }

    public func testAccentRemoval_NullValue_ReturnNullSuccessfully(): Unit {
        throw Exception('TODO')
    }

    public func testRemoveSingleDoubleConsonants_BUBLE_RemovedSuccessfully(): Unit {
        throw Exception('TODO')
    }

    public func testRemoveDoubleConsonants_MISSISSIPPI_RemovedSuccessfully(): Unit {
        throw Exception('TODO')
    }

    public func testRemoveDoubleDoubleVowel_BEETLE_NotRemoved(): Unit {
        throw Exception('TODO')
    }

    public func testIsVowel_CapitalA_ReturnsTrue(): Unit {
        throw Exception('TODO')
    }

    public func testIsVowel_SmallD_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testRemoveVowel_ALESSANDRA_Returns_ALSSNDR(): Unit {
        throw Exception('TODO')
    }

    public func testRemoveVowel__AIDAN_Returns_ADN(): Unit {
        throw Exception('TODO')
    }

    public func testRemoveVowel__DECLAN_Returns_DCLN(): Unit {
        throw Exception('TODO')
    }

    public func testGetFirstLast3__ALEXANDER_Returns_Aleder(): Unit {
        throw Exception('TODO')
    }

    public func testGetFirstLast3_PETE_Returns_PETE(): Unit {
        throw Exception('TODO')
    }

    public func testleftTorightThenRightToLeft_ALEXANDER_ALEXANDRA_Returns4(): Unit {
        throw Exception('TODO')
    }

    public func testleftTorightThenRightToLeft_EINSTEIN_MICHAELA_Returns0(): Unit {
        throw Exception('TODO')
    }

    public func testGetMinRating_7_Return4_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testGetMinRating_1_Returns5_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testGetMinRating_2_Returns5_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_5_Returns4_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_5_Returns4_Successfully2(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_6_Returns4_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_7_Returns4_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_8_Returns3_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_10_Returns3_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testgetMinRating_11_Returns_3_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testGetMinRating_13_Returns_1_Successfully(): Unit {
        throw Exception('TODO')
    }

    public func testcleanName_SuccessfullyClean(): Unit {
        throw Exception('TODO')
    }

    public func testisVowel_SingleVowel_ReturnsTrue(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_SecondNameNothing_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_FirstNameNothing_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_SecondNameJustSpace_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_FirstNameJustSpace_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_SecondNameNull_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_FirstNameNull_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEquals_CornerCase_FirstNameJust1Letter_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testisEncodeEqualsSecondNameJust1Letter_ReturnsFalse(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_HARPER_HRPR(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_SMITH_to_SMTH(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_SMYTH_to_SMYTH(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_Space_to_Nothing(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_NoSpace_to_Nothing(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_Null_to_Nothing(): Unit {
        throw Exception('TODO')
    }

    public func testGetEncoding_One_Letter_to_Nothing(): Unit {
        throw Exception('TODO')
    }

    public func testCompareNameNullSpace_ReturnsFalseSuccessfully(): Unit {
        throw Exception('TODO')
    }

    public func testCompareNameSameNames_ReturnsFalseSuccessfully(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SMITH_SMYTH_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_BURNS_BOURNE_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_ShortNames_AL_ED_WorksButNoMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_CATHERINE_KATHRYN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_BRIAN_BRYAN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SEAN_SHAUN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_COLM_COLIN_WithAccentsAndSymbolsAndSpaces_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_STEPHEN_STEVEN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_STEVEN_STEFAN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_STEPHEN_STEFAN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SAM_SAMUEL_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_MICKY_MICHAEL_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_OONA_OONAGH_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SOPHIE_SOFIA_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_FRANCISZEK_FRANCES_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_TOMASZ_TOM_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SmallInput_CARK_Kl_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompareNameToSingleLetter_KARL_C_DoesNotMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_ZACH_ZAKARIA_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_KARL_ALESSANDRO_DoesNotMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Forenames_UNA_OONAGH_ShouldSuccessfullyMatchButDoesNot(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_OSULLIVAN_OSUILLEABHAIN_SuccessfulMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_LongSurnames_MORIARTY_OMUIRCHEARTAIGH_DoesNotSuccessfulMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_LongSurnames_OMUIRCHEARTAIGH_OMIREADHAIGH_SuccessfulMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_COOPERFLYNN_SUPERLYN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_HAILEY_HALLEY_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_AUERBACH_UHRBACH_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_MOSKOWITZ_MOSKOVITZ_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_LIPSHITZ_LIPPSZYC_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_LEWINSKY_LEVINSKI_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_SZLAMAWICZ_SHLAMOVITZ_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_ROSOCHOWACIEC_ROSOKHOVATSETS_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surname_PRZEMYSL_PSHEMESHIL_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_PETERSON_PETERS_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_MCGOWAN_MCGEOGHEGAN_SuccessfullyMatched(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SurnamesCornerCase_MURPHY_Space_NoMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SurnamesCornerCase_MURPHY_NoSpace_NoMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_SurnameCornerCase_Nulls_NoMatch(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Surnames_MURPHY_LYNCH_NoMatchExpected(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Forenames_SEAN_JOHN_MatchExpected(): Unit {
        throw Exception('TODO')
    }

    public func testCompare_Forenames_SEAN_PETE_NoMatchExpected(): Unit {
        throw Exception('TODO')
    }

    protected func createStringEncoder(): Any {
        throw Exception('TODO')
    }

    // Methods End
}

